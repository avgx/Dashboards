import SwiftUI
import DashboardsCore

@available(iOS 17.0, *)
struct TimeChartTabView: View {
    @EnvironmentObject private var core: DashboardsCore
    @State private var widget: DashbordWidget?
    
    var body: some View {
        Group {
            if let widget = widget {
                TimeSeriesChartWidgetView(widget: widget)
            } else {
                ProgressView("Loading Widget...")
            }
        }
        .navigationTitle("Time Chart")
        .task {
            await findWidget()
        }
    }
    
    private func findWidget() async {
        guard case let .success(dashboards) = core.dashboards else { return }
        
        for dashboard in dashboards {
            if let found = dashboard.widgets.first(where: { widget in
                guard let visualization = widget.visualization else { return false }
                guard let chartType = visualization.chartType else { return false }
                guard let xField = visualization.x else { return false }
                
                let isBar = (chartType == "Bar")
                let xLowercased = xField.lowercased()
                let isTimeBased = xLowercased.contains("time") ||
                xLowercased.contains("date") ||
                xLowercased.contains("hour")
                
                return isBar && isTimeBased
            }) {
                self.widget = found
                break
            }
        }
    }
}
