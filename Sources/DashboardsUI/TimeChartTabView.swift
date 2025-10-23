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
                ProgressView("Загрузка виджета...")
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
                let visualization = widget.visualization
                let chartType = visualization?.chartType
                let xField = visualization?.x
                let isBar = (chartType == "Bar")
                let isTimeBased = (xField == "time.month" || xField == "datetime.hour")
                return isBar && isTimeBased
            }) {
                self.widget = found
                break
            }
        }
    }
}
