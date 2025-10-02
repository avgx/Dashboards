import SwiftUI
import DashboardsCore

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *) {
                ContentView()
            } else {
                // Fallback on earlier versions
                Text("need iOS 16+")
            }
        }
    }
}
