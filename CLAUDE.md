# IL2 Launcher — Raccourcis bureau Solo / Multi

Petit utilitaire Windows pour lancer IL-2 Sturmovik Great Battles en mode **Solo** ou **Multijoueur**
depuis deux raccourcis bureau, sans avoir à modifier manuellement le `startup.cfg` ni redémarrer le jeu.

---

## Contexte

IL-2 Sturmovik charge sa configuration au démarrage depuis `startup.cfg`.
Les modes Solo et Multi nécessitent des paramètres différents (notamment le paramètre `mods`).
Ce projet crée deux scripts PowerShell + deux raccourcis `.lnk` sur le bureau qui automatisent :
1. La sélection du bon fichier de configuration
2. Le lancement du jeu en mode VR OpenXR
3. (Multi uniquement) Le lancement de SRS Radio

---

## Chemins à configurer

Renseigner ces variables dans chaque script avant utilisation :

```
IL2_DIR       = TODO: chemin du dossier d'installation IL-2
                ex : C:\Program Files (x86)\Steam\steamapps\common\IL-2 Sturmovik Battle of Stalingrad
IL2_EXE       = C:\Program Files (x86)\Steam\steamapps\common\IL-2 Sturmovik Battle of Stalingrad\bin\game\Il-2.exe  (à vérifier selon installation)
SRS_EXE       = TODO: chemin de l'exécutable SRS Radio
                ex : C:\Program Files\DCS-SimpleRadio-Standalone\SR-ClientRadio.exe
```

---

## Structure du projet

```
IL2_LAUNCHER/
├── CLAUDE.md               # Ce fichier
├── launch_solo.ps1         # Script mode Solo
├── launch_multi.ps1        # Script mode Multijoueur
└── create_shortcuts.ps1    # Script de création des raccourcis bureau (run once)
```

Les raccourcis `.lnk` sont créés sur le bureau Windows et pointent vers les scripts `.ps1`.
Ils ne font pas partie du dépôt.

---

## Comportement des scripts

### `launch_solo.ps1`

1. Dans `C:\Program Files (x86)\Steam\steamapps\common\IL-2 Sturmovik Battle of Stalingrad\data\startup_solo.cfg` : vérifier que le paramètre `mods = 1` est bien présent
2. Copier `startup_solo.cfg` → `startup.cfg` (écrase l'existant)
3. Lancer `$IL2_EXE` avec les flags VR OpenXR (voir section VR ci-dessous)

### `launch_multi.ps1`

1. Dans `C:\Program Files (x86)\Steam\steamapps\common\IL-2 Sturmovik Battle of Stalingrad\data\startup_multi.cfg` : vérifier que le paramètre `mods = 0` est bien présent
2. Copier `startup_multi.cfg` → `startup.cfg` (écrase l'existant)
3. Lancer `$SRS_EXE` en arrière-plan
4. Lancer `$IL2_EXE` avec les flags VR OpenXR

---

## Paramètre `mods` dans les fichiers cfg

Les deux fichiers de config préexistants doivent contenir :

| Fichier               | Valeur `mods` | Description              |
|-----------------------|---------------|--------------------------|
| `startup_solo.cfg`    | `mods = 1`    | Active les mods (Solo)   |
| `startup_multi.cfg`   | `mods = 0`    | Désactive les mods (Multi) |

Les scripts **ne modifient pas** ces fichiers — ils se contentent de copier le bon vers `startup.cfg`.
L'édition initiale des deux fichiers `.cfg` est faite manuellement une seule fois.

---

## Lancement VR OpenXR

IL-2 Sturmovik supporte OpenXR via un argument de ligne de commande ou un flag dans `startup.cfg`.
À confirmer selon la version installée :

- **Option A** — Argument CLI : `game.start.exe -openxr` (à vérifier)
- **Option B** — Paramètre dans `startup.cfg` : `x360_controller=0` + section VR (si déjà configuré)

> TODO: confirmer le flag exact de lancement VR OpenXR pour cette installation.
> Source de référence : forum IL-2 ou fichier `startup.cfg` existant.

---

## Création des raccourcis bureau

`create_shortcuts.ps1` est un script à exécuter une seule fois. Il crée sur le bureau :
- **IL2 — Solo.lnk** → pointe vers `launch_solo.ps1` (icône avion à définir)
- **IL2 — Multi.lnk** → pointe vers `launch_multi.ps1` (icône radio à définir)

Les raccourcis sont configurés pour s'exécuter avec PowerShell sans afficher de fenêtre console
(`WindowStyle Hidden`).

---

## Plan d'implémentation

- [ ] Renseigner `IL2_DIR` et `SRS_EXE` dans ce fichier
- [ ] Confirmer le nom exact de l'exécutable IL-2 (`game.start.exe` ou autre)
- [ ] Confirmer le flag VR OpenXR
- [ ] Créer `startup_solo.cfg` et `startup_multi.cfg` dans le dossier data du jeu
- [ ] Écrire `launch_solo.ps1`
- [ ] Écrire `launch_multi.ps1`
- [ ] Écrire `create_shortcuts.ps1`
- [ ] Tester chaque script à la main avant de créer les raccourcis
- [ ] Exécuter `create_shortcuts.ps1`

---

## Notes

- Les scripts PowerShell nécessitent la politique d'exécution `RemoteSigned` ou `Bypass`.
  Commande à exécuter une fois en admin : `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
- SRS Radio est lancé en arrière-plan (`Start-Process`) pour ne pas bloquer le lancement du jeu.
- Si le jeu est déjà lancé, les scripts ne vérifient pas si un processus tourne — comportement à décider.
