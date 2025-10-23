import SwiftUI
import DashboardsCore

@available(iOS 17.0, *)
struct ChartContentView: View {
    @EnvironmentObject private var core: DashboardsCore
    
    let widget: DashbordWidget
    let response: QueryResponse

    var body: some View {
        switch widget.visualization?.chartType {
        case "Line":
            LineChartView(rows: response.result)
                .environmentObject(core)
        case "Donut":
            DonutChartView(rows: response.result)
                .environmentObject(core)
        case "Bar":
            BarChartView(rows: response.result)
                .environmentObject(core)
        default:
            LineChartView(rows: response.result)
                .environmentObject(core)
        }
    }
}
