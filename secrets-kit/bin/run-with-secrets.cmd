@echo off
REM Always spawns a fresh PowerShell, so injected values die with that process.
REM Resolves powershell.exe by absolute path and never by bare name, which cmd
REM would look up in the current directory first.
setlocal DisableDelayedExpansion
REM The ~dp0 path is wrong when this file is started by a quoted name found on
REM PATH; inside a CALLed label it is right.
call :skdir
if not defined SystemRoot (>&2 echo run-with-secrets: SystemRoot is not set, cannot locate Windows PowerShell.& exit /b 127)
set "__SECRETS_KIT_PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if not exist "%__SECRETS_KIT_PS%" (>&2 echo run-with-secrets: Windows PowerShell not found under SystemRoot.& exit /b 127)
REM __SECRETS_KIT_PS and __SECRETS_KIT_DIR expand when the line is read, so clearing them first keeps
REM them out of the child's environment.
set "__SECRETS_KIT_PS=" & set "__SECRETS_KIT_DIR=" & "%__SECRETS_KIT_PS%" -NoProfile -ExecutionPolicy Bypass -File "%__SECRETS_KIT_DIR%..\lib\run-with-secrets-impl.ps1" %*
exit /b %ERRORLEVEL%

:skdir
set "__SECRETS_KIT_DIR=%~dp0"
exit /b
