import SwiftUI

@main
struct DynamicIslandLoopApp: App {
    @StateObject private var manager = LiveActivityManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
        }
    }
}
