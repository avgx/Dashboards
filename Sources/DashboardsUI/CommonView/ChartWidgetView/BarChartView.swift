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
                Text("Нет данных для отображения")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 180)
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
        
        let detectedXKey = firstRow.keys.first(where: { $0.lowercased().contains("time") || $0.lowercased().contains("date") }) ?? firstRow.keys.first ?? ""
        let detectedYKey = "count"
        
        let parsed: [(String, Double)] = rows.compactMap { row in
            guard let y = row[detectedYKey]?.doubleValue else { return nil }
            let x = row[detectedXKey]?.stringValue ?? "-"
            return (x, y)
        }
        
        xKey = detectedXKey
        yKey = detectedYKey
        data = parsed
    }
}
