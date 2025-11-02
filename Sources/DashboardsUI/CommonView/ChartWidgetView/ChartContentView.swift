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
        case "Donut":
            DonutChartView(rows: response.result, response: response)
        case "Bar":
            BarChartView(rows: response.result)
        default:
            LineChartView(rows: response.result)
        }
    }
}
