# DynamicIslandLoop

Progetto pensato per essere buildato **senza mai aprire Xcode**: il file
`project.yml` descrive l'app (target principale + widget extension per la
Dynamic Island) e viene trasformato in un vero progetto Xcode al volo,
sul Mac in cloud, tramite **XcodeGen** — un solo comando, già incluso
nelle pipeline sotto.

## 1. Metti tutto su GitHub

Crea un repo (es. sotto `piedigi`) e carica **l'intero contenuto di questa
cartella così com'è**, mantenendo la struttura:

```
project.yml
App/
  DynamicIslandLoopApp.swift
  ContentView.swift
  LiveActivityManager.swift
  Info.plist
Widget/
  DynamicIslandLoopLiveActivity.swift
  DynamicIslandLoopWidgetBundle.swift
  Info.plist
Shared/
  DynamicIslandLoopAttributes.swift
codemagic.yaml
.github/workflows/build-ipa.yml
```

Importante: `project.yml` deve stare nella **root** del repo (stesso
livello di `App/`, `Widget/`, `Shared/`), non dentro una sottocartella.

## 2. Builda l'IPA — Opzione A: GitHub Actions

1. Vai su GitHub, tab **Actions** del repo
2. Seleziona "Build unsigned IPA" → **Run workflow**
3. A fine build (qualche minuto), apri la run → in fondo trovi l'artifact
   `DynamicIslandLoop-ipa` scaricabile: è il tuo `.ipa`

## 2bis. Opzione B: Codemagic

1. codemagic.io → registrati (gratis, 500 minuti macOS/mese) → collega
   il repo GitHub
2. Codemagic rileva `codemagic.yaml` da solo → **Start new build**
3. A fine build, IPA scaricabile dalla pagina della build

Entrambe fanno la stessa cosa (XcodeGen genera il progetto, poi
xcodebuild compila senza firma) — usa quella che preferisci.

## 3. Installazione

Le pipeline firmano l'IPA "ad-hoc" con **`ldid`** (una firma finta/locale)
prima di impacchettarlo — è un passaggio necessario: un binario
*completamente* privo di qualsiasi firma causa un errore di installazione
su SideStore/AltServer quando l'app contiene un'estensione (come la
nostra Widget Extension per la Dynamic Island), un problema noto e
diffuso nell'ecosistema del sideload, non specifico a questo progetto.
SideStore/AltServer rifirmano comunque tutto con il tuo Apple ID al
momento dell'installazione, come sempre.

Se avevi scaricato un IPA prima di questo aggiornamento e ti dava
l'errore "extensionDictionary must be set in placeholder attributes",
rilancia la build: dovrebbe risolversi.

## 4. Cosa fa l'app

- Un bottone Avvia/Ferma una Live Activity
- Nella Dynamic Island appare un equalizzatore a barre verticali,
  verde a sinistra che sfuma a giallo/arancio verso destra fino a
  diventare puntini (stile audio in chiamata), animato in loop continuo
- L'animazione è disegnata dal sistema stesso via `TimelineView`,
  calcolando la fase dal tempo trascorso: gira anche ad app chiusa,
  senza bisogno di server o aggiornamenti manuali
- Le Live Activity scadono comunque dopo 8 ore (limite di iOS), poi va
  riavviata dall'app

## 5. Se qualcosa va storto in build

Incollami qui l'errore esatto della pipeline (GitHub Actions o
Codemagic) e lo sistemiamo insieme.
