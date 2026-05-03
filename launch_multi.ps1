# ============================================================
# IL2 Launcher — Mode Multijoueur
# ============================================================

$IL2_DIR = "C:\Program Files (x86)\Steam\steamapps\common\IL-2 Sturmovik Battle of Stalingrad"
$IL2_EXE = "$IL2_DIR\bin\game\Il-2.exe"
$DATA_DIR = "$IL2_DIR\data"
$SRS_EXE  = "C:\Program Files\IL2-SimpleRadio-Standalone\IL2-SR-ClientRadio.exe"

# --- Vérifications préliminaires ---

$srcCfg = "$DATA_DIR\startup_multi.cfg"
$dstCfg = "$DATA_DIR\startup.cfg"

if (-not (Test-Path $IL2_EXE)) {
    Write-Error "Exécutable IL-2 introuvable : $IL2_EXE"
    exit 1
}

if ($SRS_EXE -eq "TODO") {
    Write-Error "Chemin SRS_EXE non configuré.`nOuvre launch_multi.ps1 et renseigne la variable SRS_EXE."
    exit 1
}

if (-not (Test-Path $SRS_EXE)) {
    Write-Error "Exécutable SRS Radio introuvable : $SRS_EXE"
    exit 1
}

if (-not (Test-Path $srcCfg)) {
    Write-Error "Fichier de config Multi introuvable : $srcCfg`nCrée ce fichier manuellement à partir de startup.cfg, puis mets mods = 0."
    exit 1
}

# Vérifie que mods = 0 est bien présent dans le fichier source
$cfgContent = Get-Content $srcCfg -Raw
if ($cfgContent -notmatch '(?m)^\s*modes\s*=\s*0\s*$') {
    Write-Error "Paramètre 'modes = 0' absent ou incorrect dans $srcCfg`nVérifie le fichier avant de relancer."
    exit 1
}

# --- Copie du fichier de config ---

Copy-Item -Path $srcCfg -Destination $dstCfg -Force

# --- Lancement de SRS Radio (arrière-plan) ---

Start-Process -FilePath $SRS_EXE

# --- Lancement d'IL-2 via Steam en mode VR ---

Start-Process "steam://launch/307960/vr"
