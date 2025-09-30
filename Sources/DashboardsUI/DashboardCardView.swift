import SwiftUI
import DashboardsCore
import Foundation

struct DashboardCardView: View {
    let dashboard: Dashboard
    
    var body: some View {
        NavigationLink(destination: DashboardDetailsView(dashboard: dashboard)) {
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
