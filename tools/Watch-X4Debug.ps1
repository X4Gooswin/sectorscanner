# Sector Overview - X4-Debuglog-Waechter
#
# Deterministischer Projekt-Watcher:
# - uebernimmt X4 debuglog.txt erst nach beendetem X4
# - sichert das Rohlog zuerst ausserhalb des Repositorys
# - verifiziert Kopien per SHA256
# - erzeugt lokal einen deterministischen Sector-Overview-Filter
# - behaelt die neuesten 3 Tests in debug\ und die vorherigen 10 in debug\archive\
# - loescht aeltere Tests nur als vollstaendige Debug-Artefakte
# - fuehrt keine KI-/API-Analyse aus
# - automatische Git-Aktionen sind ausschliesslich auf main und fuer debug/** erlaubt

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$DebugRoot = Join-Path $RepoRoot "debug"
$ArchiveRoot = Join-Path $DebugRoot "archive"
$PrepareScript = Join-Path $PSScriptRoot "prepare_debug_analysis.py"

$DocumentsRoot = [Environment]::GetFolderPath("MyDocuments")
$X4Root = Join-Path $DocumentsRoot "Egosoft\X4"
$GlobalDebugRoot = Join-Path $X4Root "SectorOverviewDebug"
$InboxRoot = Join-Path $GlobalDebugRoot "inbox"

$RequiredBranch = "main"
$PollSeconds = 2
$PostExitDelaySeconds = 3
$CopyRetryCount = 5
$CopyRetryDelaySeconds = 2

function Ensure-DebugFolders {
    New-Item -ItemType Directory -Path $DebugRoot -Force | Out-Null
    New-Item -ItemType Directory -Path $ArchiveRoot -Force | Out-Null
    New-Item -ItemType Directory -Path $InboxRoot -Force | Out-Null
}

function Get-TestNumbers {
    $numbers = @()
    foreach ($folder in @($DebugRoot, $ArchiveRoot)) {
        if (-not (Test-Path -LiteralPath $folder)) { continue }
        foreach ($file in Get-ChildItem -LiteralPath $folder -File -ErrorAction SilentlyContinue) {
            if ($file.BaseName -match "^(?:debug|debug_filter)_(\d+)$") {
                $numbers += [int64]$Matches[1]
            }
        }
    }
    return @($numbers | Sort-Object -Unique)
}

function Get-NextDebugNumber {
    $numbers = @(Get-TestNumbers)
    if ($numbers.Count -eq 0) { return [int64]1 }
    return ([int64](($numbers | Measure-Object -Maximum).Maximum) + 1)
}

function Get-TestArtifacts {
    param([Parameter(Mandatory = $true)][int64]$Number)

    $files = @()
    foreach ($folder in @($DebugRoot, $ArchiveRoot)) {
        if (-not (Test-Path -LiteralPath $folder)) { continue }
        foreach ($file in Get-ChildItem -LiteralPath $folder -File -ErrorAction SilentlyContinue) {
            if ($file.BaseName -match "^(?:debug|debug_filter)_(\d+)$" -and [int64]$Matches[1] -eq $Number) {
                $files += $file
            }
        }
    }
    return @($files)
}

function Get-LatestX4DebugLog {
    if (-not (Test-Path -LiteralPath $X4Root)) { return $null }
    return Get-ChildItem -LiteralPath $X4Root -Recurse -File -Filter "debuglog.txt" -ErrorAction SilentlyContinue |
        Sort-Object -Property LastWriteTimeUtc -Descending |
        Select-Object -First 1
}

function Get-CurrentAllowedBranch {
    $null = Get-Command git -ErrorAction Stop
    $branch = (& git -C $RepoRoot rev-parse --abbrev-ref HEAD 2>&1 | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) { throw "Aktueller Git-Branch konnte nicht ermittelt werden: $branch" }

    if ([string]::IsNullOrWhiteSpace($branch) -or $branch -eq "HEAD") {
        Write-Warning "[Sector Overview] Git-Automatik pausiert: detached HEAD."
        return $null
    }
    if ($branch -ne $RequiredBranch) {
        Write-Warning "[Sector Overview] Git-Automatik pausiert: erlaubt ist nur '$RequiredBranch', aktuell '$branch'."
        return $null
    }
    return $branch
}

function Pull-LatestRepositoryState {
    try {
        $branch = Get-CurrentAllowedBranch
        if ($null -eq $branch) { return $false }
        & git -C $RepoRoot pull --rebase --autostash origin $branch
        if ($LASTEXITCODE -ne 0) { throw "git pull --rebase --autostash fehlgeschlagen." }
        Write-Host "[Sector Overview] Remote-Stand aktualisiert: origin/$branch"
        return $true
    }
    catch {
        Write-Warning "[Sector Overview] Pull fehlgeschlagen: $($_.Exception.Message)"
        return $false
    }
}

function Copy-And-VerifyDebugLog {
    param([Parameter(Mandatory = $true)][System.IO.FileInfo]$Source)

    if ($Source.Length -le 0) {
        Write-Host "[Sector Overview] Debuglog ist leer; Original bleibt erhalten."
        return $null
    }

    Ensure-DebugFolders
    $number = Get-NextDebugNumber
    $suffix = "{0:D3}" -f $number
    $fileName = "debug_$suffix.txt"
    $destination = Join-Path $DebugRoot $fileName
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss_fff"
    $inboxPath = Join-Path $InboxRoot ("pending_debug_{0}_{1}.txt" -f $suffix, $timestamp)

    for ($attempt = 1; $attempt -le $CopyRetryCount; $attempt++) {
        try {
            Copy-Item -LiteralPath $Source.FullName -Destination $inboxPath -Force
            $sourceHash = (Get-FileHash -LiteralPath $Source.FullName -Algorithm SHA256).Hash
            $inboxHash = (Get-FileHash -LiteralPath $inboxPath -Algorithm SHA256).Hash
            if ($sourceHash -ne $inboxHash) { throw "Hash-Pruefung Quelle/Inbox fehlgeschlagen." }

            Copy-Item -LiteralPath $inboxPath -Destination $destination -Force
            $repoHash = (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash
            if ($inboxHash -ne $repoHash) { throw "Hash-Pruefung Inbox/Repository fehlgeschlagen." }

            Remove-Item -LiteralPath $Source.FullName -Force
            Write-Host "[Sector Overview] Importiert: $fileName"
            return [PSCustomObject]@{ Number = $number; Suffix = $suffix; InboxPath = $inboxPath }
        }
        catch {
            if (Test-Path -LiteralPath $destination) {
                Remove-Item -LiteralPath $destination -Force -ErrorAction SilentlyContinue
            }
            if ($attempt -lt $CopyRetryCount) {
                Write-Host "[Sector Overview] Kopierversuch $attempt fehlgeschlagen; neuer Versuch in $CopyRetryDelaySeconds s."
                Start-Sleep -Seconds $CopyRetryDelaySeconds
            }
            else {
                Write-Warning "[Sector Overview] Debuglog konnte nicht sicher uebernommen werden; Original bleibt erhalten. $($_.Exception.Message)"
                return $null
            }
        }
    }
    return $null
}

function Get-PythonCommand {
    $py = Get-Command py -ErrorAction SilentlyContinue
    if ($null -ne $py) {
        return [PSCustomObject]@{ Executable = $py.Source; PrefixArgs = @("-3") }
    }
    $python = Get-Command python -ErrorAction SilentlyContinue
    if ($null -ne $python) {
        return [PSCustomObject]@{ Executable = $python.Source; PrefixArgs = @() }
    }
    return $null
}

function Invoke-DeterministicFilter {
    param([Parameter(Mandatory = $true)][System.IO.FileInfo]$RawFile)

    if ($RawFile.BaseName -notmatch "^debug_(\d+)$") { return $false }
    $suffix = $Matches[1]
    $filterPath = Join-Path $RawFile.DirectoryName ("debug_filter_$suffix.txt")
    if (Test-Path -LiteralPath $filterPath) { return $true }

    if (-not (Test-Path -LiteralPath $PrepareScript)) {
        Write-Warning "[Sector Overview] Filter-Skript fehlt: $PrepareScript"
        return $false
    }

    $python = Get-PythonCommand
    if ($null -eq $python) {
        Write-Warning "[Sector Overview] Python nicht gefunden; Rohlog bleibt erhalten."
        return $false
    }

    $tempPath = "$filterPath.tmp"
    Remove-Item -LiteralPath $tempPath -Force -ErrorAction SilentlyContinue
    $args = @($python.PrefixArgs)
    $args += @($PrepareScript, "--log", $RawFile.FullName, "--output", $tempPath)

    & $python.Executable @args
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $tempPath)) {
        Remove-Item -LiteralPath $tempPath -Force -ErrorAction SilentlyContinue
        Write-Warning "[Sector Overview] Filtererzeugung fuer $($RawFile.Name) fehlgeschlagen."
        return $false
    }

    Move-Item -LiteralPath $tempPath -Destination $filterPath -Force
    Write-Host "[Sector Overview] Filter erzeugt: $([System.IO.Path]::GetFileName($filterPath))"
    return $true
}

function Process-PendingFilters {
    $success = $true
    foreach ($folder in @($DebugRoot, $ArchiveRoot)) {
        if (-not (Test-Path -LiteralPath $folder)) { continue }
        foreach ($raw in Get-ChildItem -LiteralPath $folder -File -Filter "debug_*.txt" -ErrorAction SilentlyContinue | Sort-Object Name) {
            if ($raw.BaseName -match "^debug_\d+$") {
                if (-not (Invoke-DeterministicFilter -RawFile $raw)) {
                    $success = $false
                    break
                }
            }
        }
        if (-not $success) { break }
    }
    return $success
}

function Apply-RetentionPolicy {
    Ensure-DebugFolders
    $numbers = @(Get-TestNumbers | Sort-Object -Descending)

    for ($index = 0; $index -lt $numbers.Count; $index++) {
        $number = [int64]$numbers[$index]
        $artifacts = @(Get-TestArtifacts -Number $number)

        if ($index -lt 3) {
            foreach ($file in $artifacts) {
                $target = Join-Path $DebugRoot $file.Name
                if ($file.DirectoryName -ne $DebugRoot) { Move-Item -LiteralPath $file.FullName -Destination $target -Force }
            }
        }
        elseif ($index -lt 13) {
            foreach ($file in $artifacts) {
                $target = Join-Path $ArchiveRoot $file.Name
                if ($file.DirectoryName -ne $ArchiveRoot) { Move-Item -LiteralPath $file.FullName -Destination $target -Force }
            }
        }
        else {
            foreach ($file in $artifacts) {
                Remove-Item -LiteralPath $file.FullName -Force
                Write-Host "[Sector Overview] Altes Debug-Artefakt geloescht: $($file.Name)"
            }
        }
    }
}

function Sync-DebugToGitHub {
    try {
        $branch = Get-CurrentAllowedBranch
        if ($null -eq $branch) { return $false }

        & git -C $RepoRoot add -- "debug"
        if ($LASTEXITCODE -ne 0) { throw "git add debug fehlgeschlagen." }

        & git -C $RepoRoot diff --cached --quiet -- "debug"
        if ($LASTEXITCODE -eq 0) {
            return $true
        }
        if ($LASTEXITCODE -ne 1) { throw "git diff --cached konnte den Debug-Stand nicht pruefen." }

        $numbers = @(Get-TestNumbers)
        $latest = if ($numbers.Count -gt 0) { [int64](($numbers | Measure-Object -Maximum).Maximum) } else { [int64]0 }
        $message = if ($latest -gt 0) { "debug: import and filter debug_{0:D3}.txt" -f $latest } else { "debug: update Sector Overview debug artifacts" }

        & git -C $RepoRoot commit -m $message -- "debug"
        if ($LASTEXITCODE -ne 0) { throw "Debug-Commit fehlgeschlagen." }

        & git -C $RepoRoot push origin $branch
        if ($LASTEXITCODE -ne 0) { throw "Debug-Push fehlgeschlagen." }

        Write-Host "[Sector Overview] Debug-Artefakte nach origin/$branch synchronisiert."
        return $true
    }
    catch {
        Write-Warning "[Sector Overview] Git-Synchronisierung fehlgeschlagen: $($_.Exception.Message)"
        return $false
    }
}

function Clear-VerifiedInboxAfterPush {
    if (-not (Test-Path -LiteralPath $InboxRoot)) { return }
    foreach ($file in Get-ChildItem -LiteralPath $InboxRoot -File -ErrorAction SilentlyContinue) {
        Remove-Item -LiteralPath $file.FullName -Force -ErrorAction SilentlyContinue
    }
}

function Run-DebugCycle {
    Ensure-DebugFolders

    if (-not (Pull-LatestRepositoryState)) {
        Write-Warning "[Sector Overview] Zyklus ohne Git-Aktualisierung abgebrochen; es werden keine neuen Logs importiert."
        return
    }

    $source = Get-LatestX4DebugLog
    if ($null -ne $source) {
        $null = Copy-And-VerifyDebugLog -Source $source
    }

    if (-not (Process-PendingFilters)) {
        Write-Warning "[Sector Overview] Mindestens ein Rohlog ist noch ungefiltert; keine automatische Git-Synchronisierung."
        return
    }

    Apply-RetentionPolicy

    if (Sync-DebugToGitHub) {
        Clear-VerifiedInboxAfterPush
    }
}

Ensure-DebugFolders
Write-Host "[Sector Overview] Debug-Waechter aktiv. Automatische Git-Aktionen nur auf '$RequiredBranch'."
Write-Host "[Sector Overview] Keine KI-/API-Analyse."

$wasRunning = $null -ne (Get-Process -Name "X4" -ErrorAction SilentlyContinue | Select-Object -First 1)

if (-not $wasRunning) {
    Run-DebugCycle
}

while ($true) {
    $isRunning = $null -ne (Get-Process -Name "X4" -ErrorAction SilentlyContinue | Select-Object -First 1)

    if ($wasRunning -and -not $isRunning) {
        Start-Sleep -Seconds $PostExitDelaySeconds
        Run-DebugCycle
    }

    $wasRunning = $isRunning
    Start-Sleep -Seconds $PollSeconds
}
