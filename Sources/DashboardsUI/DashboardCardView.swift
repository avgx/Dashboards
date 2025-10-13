import SwiftUI
import DashboardsCore
import Foundation

@available(iOS 17.0, *)
struct DashboardCardView: View {
    @EnvironmentObject private var core: DashboardsCore
    
    let dashboard: Dashboard
    
    var body: some View {
        NavigationLink(destination: {
            DashboardView(dashboard: dashboard)
                .environmentObject(core)
        }) {
            card
        }
    }
    
    private var card: some View {
        VStack(alignment: .leading) {
            Text(dashboard.title)
                .font(.headline)
            if let description = dashboard.description, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            if let tags = dashboard.tags, !tags.isEmpty {
                Text(tags)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
