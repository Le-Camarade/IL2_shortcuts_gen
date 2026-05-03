# ============================================================
# Creation des raccourcis bureau -- IL2 Solo / Multi
# A executer une seule fois en tant qu'utilisateur normal.
# ============================================================

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$desktop   = [Environment]::GetFolderPath("Desktop")
$shell     = New-Object -ComObject WScript.Shell

function New-Il2Shortcut {
    param(
        [string]$LinkName,
        [string]$TargetScript,
        [string]$Description
    )

    $lnkPath = Join-Path $desktop "$LinkName.lnk"
    $lnk = $shell.CreateShortcut($lnkPath)
    $lnk.TargetPath      = "powershell.exe"
    $lnk.Arguments       = "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$TargetScript`""
    $lnk.WorkingDirectory = $scriptDir
    $lnk.Description     = $Description
    $lnk.WindowStyle     = 7
    $lnk.Save()

    Write-Host "Raccourci cree : $lnkPath"
}

$soloParams = @{
    LinkName     = "IL2 -- Solo"
    TargetScript = Join-Path $scriptDir "launch_solo.ps1"
    Description  = "Lancer IL-2 en mode Solo (mods actives)"
}
New-Il2Shortcut @soloParams

$multiParams = @{
    LinkName     = "IL2 -- Multi"
    TargetScript = Join-Path $scriptDir "launch_multi.ps1"
    Description  = "Lancer IL-2 en mode Multijoueur + SRS Radio"
}
New-Il2Shortcut @multiParams

Write-Host "`nTermine. Deux raccourcis ont ete crees sur le bureau."
