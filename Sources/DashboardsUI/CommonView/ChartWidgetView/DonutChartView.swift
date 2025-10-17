import SwiftUI
import Charts
import DashboardsCore

@available(iOS 17.0, *)
struct DonutChartView: View {
    let rows: [[String: AnyCodable]]

    var body: some View {
        let (_, _, data) = parseData()

        HStack(alignment: .top, spacing: 20) {
            Chart(data, id: \.0) { item in
                SectorMark(
                    angle: .value("Value", item.1),
                    innerRadius: .ratio(0.55),
                    angularInset: 1.5
                )
                .foregroundStyle(by: .value("Category", item.0))
            }
            .frame(width: 180, height: 180)
            .chartLegend(.hidden)

            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(data, id: \.0) { item in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.accentColor.opacity(0.7))
                                .frame(width: 14, height: 14)
                            Text("\(item.0): \(item.1, specifier: "%.2f")")
                                .font(.caption)
                        }
                    }
                }
            }
            .frame(maxHeight: 180)
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
