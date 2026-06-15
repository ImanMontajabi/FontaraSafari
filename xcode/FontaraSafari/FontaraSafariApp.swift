import SwiftUI

@main
struct FontaraSafariApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .fixedSize()
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .commands {
            // Remove default menu items that don't apply to a single-window utility app.
            CommandGroup(replacing: .newItem) {}
        }
    }
}
