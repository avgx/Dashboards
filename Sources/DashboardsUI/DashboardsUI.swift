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
                        try? await core.retry()
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
    let core = DashboardsCore.shared
    DashboardsUI()
        .environmentObject(core)
        .onAppear {
            Task {
                if !core.isConnected {
                    try? await core.connect(
                        api: URL(string: ProcessInfo.processInfo.environment["API"]!)!,
                        token: ProcessInfo.processInfo.environment["TOKEN"]!)
                }
            }
        }
}
