# CredentialStore.ps1 - the only file that knows where secrets physically live.
#
# Backend: Windows Credential Manager (generic credentials), reached through the
# documented advapi32 Cred* API. No encryption is implemented here; Windows does
# it. To swap backends (age, DPAPI, a vault), rewrite the five functions at the
# bottom of this file and nothing else in the repo changes.
#
# Values are never written to the pipeline, a file, or the console by this file.

# No Set-StrictMode here on purpose: this file is dot-sourced, so setting it
# would silently change the mode of whatever shell sourced it. Both callers
# (secrets-impl.ps1, run-with-secrets-impl.ps1) set StrictMode before sourcing this.

# Every key is stored as a generic credential named <Prefix><NAME>. The prefix,
# the guarded-key list and the guard timeout come from secrets-kit.config.psd1
# one level above lib\ (next to KEYS.md) when that file exists; otherwise the
# defaults below apply. Import-PowerShellDataFile reads the file as data in
# restricted-language mode, so a config file can set values but never run code.
$script:KitRoot             = Split-Path $PSScriptRoot -Parent
$script:SecretsPrefix       = 'secrets-kit:'
$script:Guarded             = @()
$script:GuardTimeoutSeconds = 300
$script:DenyRules           = @()
$script:ConfigFile          = Join-Path $script:KitRoot 'secrets-kit.config.psd1'
if (Test-Path -LiteralPath $script:ConfigFile) {
    $cfg = Import-PowerShellDataFile -LiteralPath $script:ConfigFile
    if ($cfg.ContainsKey('Prefix')) {
        $p = [string]$cfg.Prefix
        # Letters, digits, . _ - and inner colons; must end in one colon. Keeps the
        # Credential Manager target names predictable and the wildcard enumeration exact.
        if ($p -cnotmatch '^[A-Za-z0-9][A-Za-z0-9._-]*(:[A-Za-z0-9._-]+)*:\z' -or $p.Length -gt 64) {
            throw "secrets-kit.config.psd1: Prefix must look like 'name:' or 'name:sub:' (letters, digits, . _ -), max 64 chars."
        }
        $script:SecretsPrefix = $p
    }
    if ($cfg.ContainsKey('Guarded')) {
        $script:Guarded = @([string[]]$cfg.Guarded | Where-Object { $_ } | ForEach-Object { $_.Trim() })
        foreach ($g in $script:Guarded) {
            if ($g -cnotmatch '^[A-Z][A-Z0-9_]*\z') { throw "secrets-kit.config.psd1: Guarded entry is not an UPPER_SNAKE_CASE key name." }
        }
    }
    if ($cfg.ContainsKey('GuardTimeoutSeconds')) {
        $t = [int]$cfg.GuardTimeoutSeconds
        if ($t -lt 1 -or $t -gt 3600) { throw 'secrets-kit.config.psd1: GuardTimeoutSeconds must be 1..3600.' }
        $script:GuardTimeoutSeconds = $t
    }
    if ($cfg.ContainsKey('DenyRules')) { $script:DenyRules = @([string[]]$cfg.DenyRules | Where-Object { $_ }) }
    Remove-Variable cfg, p, t, g -ErrorAction SilentlyContinue
}

# Names that change how a program loads code or where it connects. A stored
# credential under one of these names would be injected into every wrapped
# command and could make it load a planted module or send traffic elsewhere
# (NODE_OPTIONS=--require ..., PYTHONSTARTUP, HTTPS_PROXY, PATH). Refused by
# `secrets add` and skipped by run-with-secrets, whatever the store contains.
# Windows environment names are case-insensitive, so the test is too.
$script:ForbiddenNames = @(
    'PATH', 'PATHEXT', 'COMSPEC', 'SYSTEMROOT', 'WINDIR', 'TEMP', 'TMP', 'USERPROFILE', 'HOMEDRIVE', 'HOMEPATH',
    'NODE_OPTIONS', 'NODE_PATH', 'NODE_EXTRA_CA_CERTS', 'NODE_TLS_REJECT_UNAUTHORIZED',
    'PYTHONPATH', 'PYTHONSTARTUP', 'PYTHONHOME', 'PYTHONUSERBASE',
    'PSMODULEPATH', 'PSEXECUTIONPOLICYPREFERENCE', '__PSLOCKDOWNPOLICY',
    'HTTP_PROXY', 'HTTPS_PROXY', 'ALL_PROXY', 'NO_PROXY',
    'SSL_CERT_FILE', 'SSL_CERT_DIR', 'REQUESTS_CA_BUNDLE', 'CURL_CA_BUNDLE', 'CURL_HOME',
    'LD_PRELOAD', 'LD_LIBRARY_PATH', 'JAVA_TOOL_OPTIONS', '_JAVA_OPTIONS', 'RWS_ONLY'
)
$script:ForbiddenPrefixes = @('GIT_', 'DOTNET_', 'CLAUDE_', 'NPM_CONFIG_', 'PIP_', 'JDK_JAVA_')
function Test-ForbiddenName {
    param([Parameter(Mandatory)][string]$Name)
    $u = $Name.ToUpperInvariant()
    if ($script:ForbiddenNames -contains $u) { return $true }
    foreach ($pfx in $script:ForbiddenPrefixes) { if ($u.StartsWith($pfx)) { return $true } }
    return $false
}

# CRED_MAX_CREDENTIAL_BLOB_SIZE is 5*512 bytes = 1280 UTF-16 characters.
$script:MaxSecretChars = 1280

if (-not ('SecretsKit.CredMan' -as [type])) {
@'
using System;
using System.Runtime.InteropServices;

namespace SecretsKit
{
    public class CredInfo
    {
        public string Name;
        public long   LastWrittenFileTime;
        public int    Length;
    }

    public static class CredMan
    {
        const uint CRED_TYPE_GENERIC        = 1;
        const uint CRED_PERSIST_LOCAL_MACHINE = 2;
        const int  ERROR_NOT_FOUND          = 1168;

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        struct CREDENTIAL
        {
            public uint   Flags;
            public uint   Type;
            public IntPtr TargetName;
            public IntPtr Comment;
            public System.Runtime.InteropServices.ComTypes.FILETIME LastWritten;
            public uint   CredentialBlobSize;
            public IntPtr CredentialBlob;
            public uint   Persist;
            public uint   AttributeCount;
            public IntPtr Attributes;
            public IntPtr TargetAlias;
            public IntPtr UserName;
        }

        [DllImport("advapi32.dll", EntryPoint = "CredWriteW", CharSet = CharSet.Unicode, SetLastError = true)]
        static extern bool CredWrite(ref CREDENTIAL cred, uint flags);

        [DllImport("advapi32.dll", EntryPoint = "CredReadW", CharSet = CharSet.Unicode, SetLastError = true)]
        static extern bool CredRead(string target, uint type, uint flags, out IntPtr credPtr);

        [DllImport("advapi32.dll", EntryPoint = "CredDeleteW", CharSet = CharSet.Unicode, SetLastError = true)]
        static extern bool CredDelete(string target, uint type, uint flags);

        [DllImport("advapi32.dll", EntryPoint = "CredEnumerateW", CharSet = CharSet.Unicode, SetLastError = true)]
        static extern bool CredEnumerate(string filter, uint flags, out uint count, out IntPtr credsPtr);

        [DllImport("advapi32.dll")]
        static extern void CredFree(IntPtr buffer);

        // blob points at unmanaged UTF-16 memory owned by the caller (a SecureString
        // marshalled with SecureStringToGlobalAllocUnicode). The plaintext never
        // becomes a managed string, so it is never left on the GC heap.
        public static void Write(string name, IntPtr blob, int blobBytes)
        {
            CREDENTIAL c = new CREDENTIAL();
            c.Type               = CRED_TYPE_GENERIC;
            c.Persist            = CRED_PERSIST_LOCAL_MACHINE;
            c.TargetName         = Marshal.StringToCoTaskMemUni(name);
            c.UserName           = Marshal.StringToCoTaskMemUni(Environment.UserName);
            c.CredentialBlob     = blob;
            c.CredentialBlobSize = (uint)blobBytes;
            try
            {
                if (!CredWrite(ref c, 0))
                    throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error());
            }
            finally
            {
                Marshal.FreeCoTaskMem(c.TargetName);
                Marshal.FreeCoTaskMem(c.UserName);
            }
        }

        // Returns the value. Only the process-launch wrapper should call this.
        public static string Read(string name)
        {
            IntPtr p;
            if (!CredRead(name, CRED_TYPE_GENERIC, 0, out p)) return null;
            try
            {
                CREDENTIAL c = (CREDENTIAL)Marshal.PtrToStructure(p, typeof(CREDENTIAL));
                if (c.CredentialBlobSize == 0) return String.Empty;
                return Marshal.PtrToStringUni(c.CredentialBlob, (int)(c.CredentialBlobSize / 2));
            }
            finally { CredFree(p); }
        }

        // Length without decoding the value: lets `secrets check` prove a key is
        // non-empty. CredRead still decrypts the blob into its own buffer; it is
        // never copied or decoded here, and CredFree releases it.
        public static int Length(string name)
        {
            IntPtr p;
            if (!CredRead(name, CRED_TYPE_GENERIC, 0, out p)) return -1;
            try
            {
                CREDENTIAL c = (CREDENTIAL)Marshal.PtrToStructure(p, typeof(CREDENTIAL));
                return (int)(c.CredentialBlobSize / 2);
            }
            finally { CredFree(p); }
        }

        public static bool Delete(string name)
        {
            if (CredDelete(name, CRED_TYPE_GENERIC, 0)) return true;
            if (Marshal.GetLastWin32Error() == ERROR_NOT_FOUND) return false;
            throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error());
        }

        // Names and metadata only. CredEnumerate returns the decrypted blobs too;
        // they are never copied or decoded, and CredFree releases them.
        public static CredInfo[] Enumerate(string filter)
        {
            uint count; IntPtr arr;
            if (!CredEnumerate(filter, 0, out count, out arr))
            {
                int err = Marshal.GetLastWin32Error();
                if (err == ERROR_NOT_FOUND) return new CredInfo[0];
                throw new System.ComponentModel.Win32Exception(err);
            }
            try
            {
                CredInfo[] outp = new CredInfo[count];
                for (int i = 0; i < count; i++)
                {
                    IntPtr cp = Marshal.ReadIntPtr(arr, i * IntPtr.Size);
                    CREDENTIAL c = (CREDENTIAL)Marshal.PtrToStructure(cp, typeof(CREDENTIAL));
                    CredInfo ci = new CredInfo();
                    ci.Name   = Marshal.PtrToStringUni(c.TargetName);
                    ci.Length = (int)(c.CredentialBlobSize / 2);
                    ci.LastWrittenFileTime =
                        ((long)(uint)c.LastWritten.dwHighDateTime << 32) | (uint)c.LastWritten.dwLowDateTime;
                    outp[i] = ci;
                }
                return outp;
            }
            finally { CredFree(arr); }
        }
    }
}
'@ | ForEach-Object { Add-Type -TypeDefinition $_ -Language CSharp -Debug:$false }
}
# -Debug:$false above is load-bearing, not tidiness. Add-Type emits the C# source
# as a DEBUG record; if a caller passed -Debug then $DebugPreference is 'Inquire'
# and that record becomes a ShouldContinue prompt, which reads its answer from
# stdin and ECHOES the line it read. With a value piped in, that prints the secret.

function Get-SecretTarget([string]$Name) { return "$($script:SecretsPrefix)$Name" }

# ---------------------------------------------------------------------------
# The backend seam. Swapping stores means rewriting only what is below.
# ---------------------------------------------------------------------------

# Takes a SecureString so no caller ever handles plaintext.
function Set-Secret {
    param([Parameter(Mandatory)][string]$Name,
          [Parameter(Mandatory)][System.Security.SecureString]$Value)

    if ($Value.Length -eq 0) { throw "Refusing to store an empty value for $Name." }
    if ($Value.Length -gt $script:MaxSecretChars) {
        throw "Value for $Name is $($Value.Length) chars; Credential Manager caps a generic credential at $($script:MaxSecretChars). Use a file-based backend for values this large."
    }

    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($Value)
    try   { [SecretsKit.CredMan]::Write((Get-SecretTarget $Name), $ptr, $Value.Length * 2) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeGlobalAllocUnicode($ptr) }
}

# The one function that returns plaintext. Only run-with-secrets-impl.ps1 calls it.
function Get-SecretValue {
    param([Parameter(Mandatory)][string]$Name)
    return [SecretsKit.CredMan]::Read((Get-SecretTarget $Name))
}

# -1 = not set. Never decodes or returns the value.
function Get-SecretLength {
    param([Parameter(Mandatory)][string]$Name)
    return [SecretsKit.CredMan]::Length((Get-SecretTarget $Name))
}

function Remove-Secret {
    param([Parameter(Mandatory)][string]$Name)
    return [SecretsKit.CredMan]::Delete((Get-SecretTarget $Name))
}

# Names + last-written + length. No values.
function Get-SecretIndex {
    $prefixLen = $script:SecretsPrefix.Length
    foreach ($c in [SecretsKit.CredMan]::Enumerate("$($script:SecretsPrefix)*")) {
        $when = $null
        if ($c.LastWrittenFileTime -gt 0) {
            try { $when = [DateTime]::FromFileTimeUtc($c.LastWrittenFileTime).ToLocalTime() } catch { $when = $null }
        }
        [pscustomobject]@{
            Name        = $c.Name.Substring($prefixLen)
            LastWritten = $when
            Length      = $c.Length
        }
    }
}
