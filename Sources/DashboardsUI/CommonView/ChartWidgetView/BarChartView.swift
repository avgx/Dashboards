import SwiftUI
import Charts
import DashboardsCore

@available(iOS 17.0, *)
struct BarChartView: View {
    let rows: [[String: AnyCodable]]
    
    @State private var xKey: String = ""
    @State private var yKey: String = ""
    @State private var data: [(String, Double)] = []
    
    var body: some View {
        VStack {
            if data.isEmpty {
               EmptyView(message: "No data available...")
            } else {
                Chart(data, id: \.0) { item in
                    BarMark(
                        x: .value("X", item.0),
                        y: .value("Y", item.1)
                    )
                    .foregroundStyle(.blue)
                }
                .chartXAxisLabel(position: .bottom, alignment: .center) {
                    Text(xKey)
                }
                .chartYAxisLabel(position: .leading, alignment: .center) {
                    Text(yKey)
                }
                .frame(maxWidth: .infinity, minHeight: 180)
                .transition(.opacity.combined(with: .scale))
            }
        }
        .onAppear {
            parseData()
        }
    }
    
    private func parseData() {
        guard let firstRow = rows.first else { return }
        
        let detectedXKey = firstRow.keys.first(where: {
            $0.lowercased().contains("time") || $0.lowercased().contains("date")
        }) ?? firstRow.keys.first ?? ""
        
        let detectedYKey = firstRow.keys.first(where: { key in
            guard key != detectedXKey else { return false }
            return firstRow[key]?.doubleValue != nil
        }) ?? "count"
        
        let parsed: [(String, Double)] = rows.compactMap { row in
            guard let y = row[detectedYKey]?.doubleValue else { return nil }
            let xRaw = row[detectedXKey]?.stringValue ?? "-"
            
            let x: String
            if detectedXKey.lowercased().contains("date") || 
               detectedXKey.lowercased().contains("time") ||
               detectedXKey.lowercased().contains("hour") ||
               detectedXKey.lowercased().contains("month"),
               let date = QueryResponse.parseDate(from: xRaw) {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ru_RU")
                if detectedXKey.lowercased().contains("hour") {
                    formatter.dateFormat = "HH:mm"
                } else if detectedXKey.lowercased().contains("month") {
                    formatter.dateFormat = "MMM"
                } else {
                    formatter.dateFormat = "dd.MM"
                }
                x = formatter.string(from: date)
            } else {
                x = xRaw
            }
            
            return (x, y)
        }
        
        xKey = detectedXKey
        yKey = detectedYKey
        data = parsed
    }
}
