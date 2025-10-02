import SwiftUI
import DashboardsCore
import DashboardsUI

@available(iOS 16.0, *)
@MainActor
struct ContentView: View {
    @StateObject var core = DashboardsCore.shared
    
    var body: some View {
        //TODO: чуть позже я сюда скопирую реальный вход в облако. Пока как и в пакете - через environment
        NavigationStack {
            DashboardsUI()
                .environmentObject(core)
                .onAppear {
                    core.set(
                        api: URL(string: ProcessInfo.processInfo.environment["API"]!)!,
                        token: ProcessInfo.processInfo.environment["TOKEN"]!
                    )
                }
        }
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        ContentView()
    } else {
        // Fallback on earlier versions
        Text("need iOS 16+")
    }
}
