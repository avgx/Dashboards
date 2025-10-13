import SwiftUI
import DashboardsCore
import Foundation

struct DashboardsListView: View {
    let dashboards: [Dashboard]
    
    var body: some View {
        List(dashboards, id: \.id) { dashboard in
            DashboardCardView(dashboard: dashboard)
        }
    }
}
