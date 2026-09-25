import SwiftUI

struct ContentView: View {
    @EnvironmentObject var manager: LiveActivityManager

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "circle.dotted")
                .font(.system(size: 60))
                .symbolEffect(.pulse)

            Text(manager.isRunning ? "Loop attivo nella Dynamic Island" : "Loop fermo")
                .font(.headline)

            Button(manager.isRunning ? "Ferma" : "Avvia") {
                manager.isRunning ? manager.stop() : manager.start()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView().environmentObject(LiveActivityManager())
}
