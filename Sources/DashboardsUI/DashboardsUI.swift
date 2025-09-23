import SwiftUI
import DashboardsCore

@MainActor
public struct DashboardsUI: View {
    @EnvironmentObject private var core: DashboardsCore
    
    public init() { }
    
    public var body: some View {
        Text("TODO: DashboardsUI")
        
        Text("\(core.isConnected)")
    }
}

#Preview {
    DashboardsUI()
        .environmentObject(DashboardsCore.shared)
        .task {
            try? await Task.sleep(nanoseconds: NSEC_PER_SEC)
            try? await DashboardsCore.shared.connect(api: URL(string: "https://mycloud.com/")!, token: "eyJhbGciOi...nH8ag")
        }
}
