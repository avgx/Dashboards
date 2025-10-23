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
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 5))
        }
        .chartXAxisLabel(position: .bottom, alignment: .center) {
            Text(xKey)
        }
        .chartYAxisLabel(position: .leading, alignment: .center) {
            Text(yKey)
        }
        .frame(maxWidth: .infinity, minHeight: 180)
    }
    
    private func parseData() -> (xKey: String, yKey: String, data: [(Date, Double)]) {
        guard let firstRow = rows.first else {
            return ("", "", [])
        }
        
        let xKey = firstRow.keys.first(where: {
            $0.lowercased().contains("time") || $0.lowercased().contains("date")
        }) ?? firstRow.keys.first ?? ""
        
        let yKey = firstRow.keys.first(where: { key in
            guard key != xKey else { return false }
            return firstRow[key]?.doubleValue != nil
        }) ?? "count"
        
        let formatter = ISO8601DateFormatter()
        
        let data: [(Date, Double)] = rows.compactMap { row in
            guard let y = row[yKey]?.doubleValue else { return nil }
            
            if let dateString = row[xKey]?.stringValue,
               let date = formatter.date(from: dateString) {
                return (date, y)
            }
            
            return nil
        }
        .sorted { $0.0 < $1.0 }
        
        return (xKey, yKey, data)
    }
}
