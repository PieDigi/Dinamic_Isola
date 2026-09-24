# DynamicIslandLoop — Scheletro progetto

Non posso compilare l'IPA qui (niente macOS/Xcode in questo ambiente), ma ecco
tutto il codice pronto da incollare in un progetto Xcode vero. Una volta
compilato con Xcode, l'IPA risultante puoi installarlo con SideStore come
per il tool di crittografia.

## 1. Crea il progetto in Xcode

1. File → New → Project → **App**
   - Product Name: `DynamicIslandLoop`
   - Interface: SwiftUI
   - Language: Swift
2. Con il progetto aperto: File → New → Target → **Widget Extension**
   - Product Name: `DynamicIslandLoopWidget`
   - **Spunta "Include Live Activity"** (fondamentale)
   - Quando chiede di attivare lo scheme, dì sì

Xcode ti crea già dei file placeholder nel target Widget: puoi cancellarli
e sostituirli con `DynamicIslandLoopLiveActivity.swift` qui sotto.

## 2. Dove mettere i file

- `App/DynamicIslandLoopApp.swift` → target app principale
- `App/ContentView.swift` → target app principale
- `App/LiveActivityManager.swift` → target app principale
- `App/DynamicIslandLoopAttributes.swift` → **su ENTRAMBI i target**
  (seleziona il file in Xcode → File Inspector a destra → Target Membership
  → spunta sia l'app che il widget extension)
- `Widget/DynamicIslandLoopLiveActivity.swift` → target Widget Extension

## 3. Info.plist dell'app principale

Aggiungi questa chiave (Xcode: seleziona Info.plist → tasto destro → Add Row):

```
Key: NSSupportsLiveActivities
Type: Boolean
Value: YES
```

## 4. Come funziona il loop infinito

La Dynamic Island qui non viene "aggiornata a mano" ogni tot secondi
dall'app — quello si ferma appena l'app va in background. Invece la view
usa `TimelineView(.animation)`, che è renderizzata direttamente dal sistema:
calcola la fase dell'animazione dalla data corrente (`Date()`), quindi
continua a girare anche ad app completamente chiusa, finché la Live
Activity è attiva.

Per fermarla basta il bottone "Stop" nell'app (o aspettare la scadenza di
8 ore che iOS impone alle Live Activities — dopodiché va riavviata).

## 5. Grafica: equalizzatore stile chiamata

`DynamicIslandLoopLiveActivity.swift` ora disegna barre verticali verdi
che sfumano a giallo/arancio verso destra fino a diventare puntini, come
nella waveform delle chiamate — animate con un'oscillazione tipo audio
reale (fasi leggermente sfalsate tra le barre).

## 6. Come ottenere l'IPA senza un Mac tuo

Io non posso compilare (niente Xcode/macOS in questo ambiente), ma il
repo include già `.github/workflows/build-ipa.yml`: una GitHub Action
che builda l'app sui runner macOS gratuiti di GitHub.

Passaggi:
1. Crea il progetto Xcode come al punto 1, incolla i file come indicato.
2. Crea un repo GitHub (es. sotto `piedigi`) e pusha tutto, incluso
   `.github/workflows/build-ipa.yml`.
3. Vai su GitHub → tab **Actions** del repo → seleziona "Build unsigned IPA"
   → **Run workflow**.
4. A fine build, nella pagina della run trovi l'artifact
   `DynamicIslandLoop-ipa` scaricabile: è il tuo `.ipa`.
5. Installalo con SideStore come al solito — l'IPA non è firmato,
   ci pensa SideStore/AltServer a firmarlo con il tuo Apple ID
   all'installazione, come fa già normalmente.

Nessun Mac necessario da parte tua in questo passaggio.

### Opzione B: Codemagic (probabilmente il "sito" che avevi usato per crittos)

`codemagic.yaml` nel repo fa la stessa cosa ma da interfaccia web:

1. Vai su codemagic.io, registrati (gratis, 500 minuti macOS/mese)
2. Collega il tuo repo GitHub con dentro il progetto Xcode
3. Codemagic rileva `codemagic.yaml` in automatico → Start new build
4. A fine build, IPA scaricabile dalla pagina della build

Stessa build "senza firma" di GitHub Actions, solo con interfaccia web
invece che tab Actions — usa quella che ti torna più comoda.
