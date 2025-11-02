import SwiftUI
import DashboardsCore

@available(iOS 17.0, *)
struct SummaryView: View {
    @EnvironmentObject private var core: DashboardsCore
    @State private var widgets: [DashbordWidget] = []
    @State private var widgetToDashboard: [String: Dashboard] = [:]
    @State private var loading = true
    
    var body: some View {
        Group {
            if loading {
                LoadingView(message: "Loading Summary...")
            } else if widgets.isEmpty {
                EmptyView(message: "No Summary Data Found...")
            } else {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 14),
                        GridItem(.flexible(), spacing: 14)
                    ], spacing: 14) {
                        ForEach(widgets, id: \.id) { widget in
                            NavigationLink {
                                TimeSeriesChartWidgetView(widget: widget)
                                    .environmentObject(core)
                            } label: {
                                SummaryCardView(widget: widget)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Summary")
        .task {
            await loadWidgets()
        }
    }
    
    private func loadWidgets() async {
        guard case let .success(dashboards) = core.dashboards else { return }

        var widgetMap: [String: Dashboard] = [:]
        let found = dashboards
            .flatMap { dashboard in
                dashboard.widgets.map { widget in
                    widgetMap[widget.id] = dashboard
                    return (widget: widget, dashboard: dashboard)
                }
            }
            .filter { item in
                let widget = item.widget
                guard let v = widget.visualization,
                      let type = v.chartType,
                      let x = v.x else { return false }
                
                let isBar = type == "Bar"
                let axis = x.lowercased()
                let timeBased = axis.contains("time") ||
                                axis.contains("date") ||
                                axis.contains("hour")

                return isBar && timeBased
            }
            .map { $0.widget }

        widgets = found
        widgetToDashboard = widgetMap
        loading = false
    }
    
}
