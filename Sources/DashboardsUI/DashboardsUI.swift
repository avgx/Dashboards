import SwiftUI
import DashboardsCore

@MainActor
@available(iOS 16.0, *)
public struct DashboardsUI: View {
    @EnvironmentObject private var core: DashboardsCore
    
    public init() { }
    
    public var body: some View {
        NavigationStack {
            content
                .navigationTitle("Dashboards")
                .task {
                    if !core.isConnected {
                        try? await core.connect(api: URL(string: "https://bezeq-pos1.axxoncloud.com/")!, token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySUQiOjMsIkNsaWVudElEIjoiZGNkNzAzNTE4YWFiMDM0MGZmOWI4MzEwMGEwOTZkNWMiLCJUeXBlIjoiYWNjZXNzVG9rZW4iLCJWZXJzaW9uIjoidjIiLCJDcmVhdGVkQXQiOiIyMDI1LTA5LTI5VDA5OjAzOjI4LjU0MDg5NjM1MloiLCJleHAiOjE3NTkyMjMwMDgsImlhdCI6MTc1OTEzNjYwOCwiaXNzIjoiQ2xvdWQifQ.V8qgUjBomrnh9g3FaEZlw4zzZc7viQJUzNhh_Bru-eU")
                    }
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if !core.isConnected {
            LoadingView(message: "Connecting...")
        } else if !core.isLoaded {
            LoadingView(message: "Loading data...")
        } else {
            switch core.dashboards {
            case .pending, .loading:
                LoadingView(message: "Loading dashboards...")
            case .error(let error):
                ErrorView(error: error) {
                    Task {
                        try? await core.connect(api: URL(string: "https://bezeq-pos1.axxoncloud.com/")!, token: "TOKEN")
                    }
                }
            case .success(let dashboards):
                if dashboards.isEmpty {
                    EmptyView(message: "No dashboards available")
                } else {
                    DashboardsListView(dashboards: dashboards)
                }
            }
        }
    }

}

@available(iOS 16.0, *)
#Preview {
    DashboardsUI()
        .environmentObject(DashboardsCore.shared)
}
