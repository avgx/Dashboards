import SwiftUI
import DashboardsCore

@available(iOS 17.0, *)
struct ChartContentView: View {
    let widget: DashbordWidget
    let response: QueryResponse

    var body: some View {
        switch widget.visualization?.chartType {
        case "Line":
            LineChartView(rows: response.result)
        case "Donut":
            DonutChartView(rows: response.result)
        default:
            Text("Unsupported chart type")
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, minHeight: 200)
        }
    }
}
