import SwiftUI
import DashboardsCore
import Foundation

@available(iOS 17.0, *)
struct DashboardsListView: View {
    let dashboards: [Dashboard]
    
    var body: some View {
        List(dashboards, id: \.id) { dashboard in
            DashboardCardView(dashboard: dashboard)
        }
    }
}
