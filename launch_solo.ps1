# ============================================================
# IL2 Launcher — Mode Solo
# ============================================================

$IL2_DIR  = "C:\Program Files (x86)\Steam\steamapps\common\IL-2 Sturmovik Battle of Stalingrad"
$IL2_EXE  = "$IL2_DIR\bin\game\Il-2.exe"
$DATA_DIR = "$IL2_DIR\data"

# --- Vérifications préliminaires ---

$srcCfg = "$DATA_DIR\startup_solo.cfg"
$dstCfg = "$DATA_DIR\startup.cfg"

if (-not (Test-Path $IL2_EXE)) {
    Write-Error "Exécutable IL-2 introuvable : $IL2_EXE"
    exit 1
}

if (-not (Test-Path $srcCfg)) {
    Write-Error "Fichier de config Solo introuvable : $srcCfg`nCrée ce fichier manuellement à partir de startup.cfg, puis mets mods = 1."
    exit 1
}

# Vérifie que mods = 1 est bien présent dans le fichier source
$cfgContent = Get-Content $srcCfg -Raw
if ($cfgContent -notmatch '(?m)^\s*modes\s*=\s*1\s*$') {
    Write-Error "Paramètre 'modes = 1' absent ou incorrect dans $srcCfg`nVérifie le fichier avant de relancer."
    exit 1
}

# --- Copie du fichier de config ---

Copy-Item -Path $srcCfg -Destination $dstCfg -Force

# --- Lancement d'IL-2 via Steam en mode VR ---

Start-Process "steam://launch/307960/vr"
