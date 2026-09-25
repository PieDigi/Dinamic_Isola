import ActivityKit
import Foundation

@MainActor
final class LiveActivityManager: ObservableObject {
    @Published var currentActivity: Activity<DynamicIslandLoopAttributes>?

    var isRunning: Bool { currentActivity != nil }

    func start() {
        guard currentActivity == nil else { return }

        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities disabilitate nelle Impostazioni di iOS.")
            return
        }

        let attributes = DynamicIslandLoopAttributes(name: "loop")
        let initialState = DynamicIslandLoopAttributes.ContentState(startedAt: Date())

        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: nil),
                pushType: nil // nessun server: gestita solo localmente
            )
            currentActivity = activity
        } catch {
            print("Errore avvio Live Activity: \(error)")
        }
    }

    func stop() {
        guard let activity = currentActivity else { return }
        Task {
            await activity.end(nil, dismissalPolicy: .immediate)
            currentActivity = nil
        }
    }
}
