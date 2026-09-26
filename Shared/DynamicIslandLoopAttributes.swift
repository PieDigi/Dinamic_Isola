import ActivityKit
import Foundation

// Questo file va aggiunto a ENTRAMBI i target (app + widget extension),
// perché sia l'app che la Dynamic Island devono conoscere questa struct.

struct DynamicIslandLoopAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Data di inizio del loop: la view calcola la fase dell'animazione
        // da questa data + Date(), non serve aggiornarla mai.
        var startedAt: Date
    }

    // Dati fissi per tutta la durata della Live Activity (non cambiano).
    var name: String
}
