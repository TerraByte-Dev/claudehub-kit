<#
.SYNOPSIS
  Scaffold a new ICM (Interpretable Context Methodology) structure.

.DESCRIPTION
  Creates a workspace folder with a canon CLAUDE.md, an AGENTS.md pointer, and one numbered
  stage room (each with a CONTEXT.md) per -Stages entry. Self-contained and safe to re-run:
  existing files are left untouched unless -Force is given. Markdown-first by design - this
  script only lays the skeleton; fill the contracts (by hand or with an agent) afterward.

  Generated files are intentionally ASCII-only (em dashes / middots become '-') so they are
  robust to Windows PowerShell 5.1's codepage handling. Punctuate them however you like once
  you fill in the TODOs.

.EXAMPLE
  .\New-IcmStructure.ps1 -Name "Invoice Pipeline" -Stages 01-intake,02-normalize,03-export

.EXAMPLE
  .\New-IcmStructure.ps1 -Name "MyThing" -Path "$HOME\Desktop"
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory)] [string] $Name,
  [string]   $Path   = (Get-Location).Path,
  [string[]] $Stages = @('01-ideate', '02-build', '03-ship'),
  [switch]   $Force
)

function Write-IfAbsent {
  param([string] $File, [string] $Content)
  if ((Test-Path $File) -and -not $Force) {
    Write-Host "  skip (exists): $File"
    return
  }
  Set-Content -Path $File -Value $Content -Encoding utf8
  Write-Host "  wrote: $File"
}

$root = Join-Path $Path $Name
New-Item -ItemType Directory -Path $root -Force | Out-Null
Write-Host "ICM structure: $root"

# --- root CLAUDE.md (canon + floor plan) ---
$rows = ($Stages | ForEach-Object { "| ``$_/`` | TODO | TODO |" }) -join "`n"
$claude = @"
# $Name - CLAUDE.md  -  Canon + Floor Plan

> This file is the **canon** for $Name. The ``AGENTS.md`` beside it only says "read this."
> Most specific file wins on conflict. ICM = Interpretable Context Methodology.

## What this is
TODO - one paragraph: what $Name is for, and the workflow it runs.

## Floor plan / routing table
| Room | Enter when... | Holds |
|------|---------------|-------|
$rows

## Principles
- Narrow context wins, one stage one job, plain-text interface, progressive disclosure.

## Hard rules
- **Source of truth:** TODO - which room/file wins all tiebreaks.
- Every folder has a ``CONTEXT.md``; every ``CLAUDE.md`` has an ``AGENTS.md`` pointer.

## Soft rules
- Numbered zones, kebab-case, explicit handoffs, CONTEXT.md <= 80 lines / references <= 200.
"@
Write-IfAbsent -File (Join-Path $root 'CLAUDE.md') -Content $claude

# --- root AGENTS.md (pointer) ---
$agents = @"
# $Name

**READ [``CLAUDE.md``](./CLAUDE.md)** - it is the canon for this structure: what it is, the
floor plan / routing table, and the rules.

This ``AGENTS.md`` exists only so Codex (and any agent that auto-discovers ``AGENTS.md``) is
routed to the same place Claude reads. One canonical doc (``CLAUDE.md``), no duplication.
"@
Write-IfAbsent -File (Join-Path $root 'AGENTS.md') -Content $agents

# --- one room per stage ---
$i = 0
foreach ($stage in $Stages) {
  $i++
  $roomDir = Join-Path $root $stage
  New-Item -ItemType Directory -Path $roomDir -Force | Out-Null

  $num    = ($stage -split '-')[0]
  $pretty = ($stage -replace '^[0-9]+-', '') -replace '-', ' '
  $pretty = (Get-Culture).TextInfo.ToTitleCase($pretty)

  $ctx = @"
# $num - $pretty  -  CONTEXT

> **Stage $i of $($Stages.Count).** TODO - one line: what this room is.

## Identity
TODO - what this room *is* and why you come here.

## Inputs
- TODO - what you bring in.

## Process
1. TODO
2. TODO

## Outputs / Handoff
- TODO - what you leave with, and where it goes next.

## Conventions
- TODO - soft rules specific to this room.

## Links
- Floor plan -> ``../CLAUDE.md``
"@
  Write-IfAbsent -File (Join-Path $roomDir 'CONTEXT.md') -Content $ctx
}

Write-Host ""
Write-Host "Done. $($Stages.Count) rooms scaffolded. Fill the contracts, then run the health checklist."
