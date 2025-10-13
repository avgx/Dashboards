import SwiftUI
import Charts
import DashboardsCore

@available(iOS 17.0, *)
struct LineChartView: View {
    let rows: [[String: AnyCodable]]

    var body: some View {
        let (xKey, yKey, data) = parseData()

        Chart(data, id: \.0) { item in
            LineMark(
                x: .value("X", item.0),
                y: .value("Y", item.1)
            )
            .foregroundStyle(.blue)
            .symbol(Circle())
        }
        .chartXAxisLabel(position: .bottom, alignment: .center) {
            Text(xKey)
        }
        .chartYAxisLabel(position: .leading, alignment: .center) {
            Text(yKey)
        }
        .frame(maxWidth: .infinity, minHeight: 180)
    }

    private func parseData() -> (xKey: String, yKey: String, data: [(String, Double)]) {
        let xKey = rows.first?.keys.first(where: { $0.contains("time") || $0.contains("date") }) ?? rows.first?.keys.first ?? ""
        let yKey = "count"

        let data: [(String, Double)] = rows.compactMap { row in
            guard let y = row[yKey]?.doubleValue else { return nil }
            let x = row[xKey]?.stringValue ?? "-"
            return (x, y)
        }

        return (xKey, yKey, data)
    }
}
