import SwiftUI
import DashboardsCore

@MainActor
@available(iOS 17.0, *)
public struct DashboardsUI: View {
    @EnvironmentObject private var core: DashboardsCore
    
    public init() { }
    
    public var body: some View {
        NavigationStack {
            content
                .navigationTitle("Dashboards")
                .task {
                    if !core.isConnected {
                        try? await core.connect()
                    }
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch core.dashboards {
        case .pending:
            LoadingView(message: "Connecting...")
        case .loading:
            LoadingView(message: "Loading dashboards...")
        case .error(let error):
            ErrorView(
                error: error,
                reloadAction: {
                    Task { try await core.retry() }
                }
            )
        case .success(let dashboards):
            DashboardsListView(dashboards: dashboards)
                .background(Color(.systemBackground))
                .overlay {
                    if dashboards.isEmpty {
                        ContentUnavailableView(
                            "No Dashboards",
                            systemImage: "chart.bar.doc.horizontal",
                            description: Text("You can create or load dashboards from the API.")
                        )
                    }
                }
        }
    }
    
}

@available(iOS 17.0, *)
#Preview {
    let core = DashboardsCore.shared
    
    DashboardsUI()
        .environmentObject(core)
        .onAppear {
            core.set(api: URL(string: ProcessInfo.processInfo.environment["API"]!)!,
                     token: ProcessInfo.processInfo.environment["TOKEN"]!)
            Task {
                if !core.isConnected {
                    try? await core.connect()
                }
            }
        }
}
