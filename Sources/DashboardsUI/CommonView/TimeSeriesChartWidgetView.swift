import SwiftUI
import Charts
import DashboardsCore

@available(iOS 17.0, *)
struct TimeSeriesChartWidgetView: View {
    @EnvironmentObject private var core: DashboardsCore
    @EnvironmentObject private var runtime: DashboardRuntime
    
    let widget: DashbordWidget
    
    @State private var selectedPeriod: PeriodTimeSeries = .day
    @State private var selectedTable: EventTable?
    @State private var chart: Resource<QueryResponse> = .pending
    @State private var refresh = UUID()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(widget.title)
                    .foregroundColor(.black)
                
                Spacer()
                
                Picker("Period", selection: $selectedPeriod) {
                    ForEach(PeriodTimeSeries.allCases, id: \.self) { period in
                        Text(period.rawValue.uppercased())
                            .font(.caption)
                            .tag(period)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 260)
                .onChange(of: selectedPeriod) { _ in refresh = UUID() }
            }
            
            if case .success(let tables) = core.eventTables {
                Picker("Table", selection: $selectedTable) {
                    Text("Select table").tag(Optional<EventTable>.none)
                    ForEach(tables, id: \.name) { table in
                        Text(table.description)
                            .tag(Optional(table))
                    }
                }
                .onChange(of: selectedTable) { _ in refresh = UUID() }
                .frame(maxWidth: 180)
            } else {
                LoadingView(message: "Loading tables...")
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("All")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(totalValue)
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(.purple.opacity(0.9))
                
                Text(periodLabel)
                    .font(.headline)
                    .foregroundColor(.black.opacity(0.8))
                    .padding(.bottom, 4)
            }
            
            content
                .frame(height: 260)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 4)
        .task(id: refresh) { await fetchData() }
        .animation(.easeInOut, value: chart)
    }
        
    private var totalValue: String {
        if case .success(let response) = chart,
           let result = response.result as? [[String: AnyCodable]],
           let firstRow = result.first {
            
            let xKey = firstRow.keys.first(where: {
                $0.lowercased().contains("time") || $0.lowercased().contains("date") || $0.lowercased().contains("hour") || $0.lowercased().contains("month")
            }) ?? ""
            
            let yKey = firstRow.keys.first(where: { key in
                guard key != xKey else { return false }
                return firstRow[key]?.doubleValue != nil
            })
            
            if let yKey = yKey {
                let total = result
                    .compactMap { $0[yKey]?.doubleValue }
                    .reduce(0, +)
                return NumberFormatter.localizedString(from: NSNumber(value: total), number: .decimal)
            }
        }
        return "—"
    }
    
    private var periodLabel: String {
        switch selectedPeriod {
        case .day: return "Today"
        case .week: return "This Week"
        case .month: return "This Month"
        case .year: return "This Year"
        }
    }
        
    @ViewBuilder
    private var content: some View {
        ZStack {
            switch chart {
            case .pending, .loading:
                LoadingView(message: "Loading Data...")
                
            case .success(let response):
                if let result = response.result as? [[String: AnyCodable]], !result.isEmpty {
                    let firstRow = result.first!
                    
                    let xKey = firstRow.keys.first(where: {
                        $0.lowercased().contains("time") || $0.lowercased().contains("date") || $0.lowercased().contains("hour") || $0.lowercased().contains("month")
                    }) ?? firstRow.keys.first ?? ""
                    
                    let yKey = firstRow.keys.first(where: { key in
                        guard key != xKey else { return false }
                        return firstRow[key]?.doubleValue != nil
                    }) ?? "count"
                    
                    let data: [(x: String, y: Double)] = result.compactMap { row in
                        guard let xRaw = row[xKey]?.stringValue,
                              let y = row[yKey]?.doubleValue else { return nil }
                        
                        let label = formatXLabel(xRaw, for: selectedPeriod)
                        return (label, y)
                    }
                    
                    if data.isEmpty {
                        Text("No data available")
                            .foregroundColor(.gray)
                    } else {
                        Chart(data, id: \.x) { item in
                            BarMark(
                                x: .value("Time", item.x),
                                y: .value("Count", item.y)
                            )
                            .foregroundStyle(.purple.gradient)
                            .cornerRadius(3)
                        }
                        .chartYAxis {
                            AxisMarks(position: .trailing)
                        }
                        .chartXAxis {
                            AxisMarks(values: .automatic) { value in
                                AxisValueLabel {
                                    if let raw = value.as(String.self) {
                                        Text(raw)
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                            .rotationEffect(.degrees(45))
                                            .frame(width: 40, alignment: .leading)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    Text("No data available")
                        .foregroundColor(.gray)
                }
                
            case .error(let error):
                ErrorView(error: error) {
                    Task { try await core.retry() }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    
    private func formatXLabel(_ raw: String, for period: PeriodTimeSeries) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        
        var date: Date?
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withTimeZone]
        date = isoFormatter.date(from: raw)
        
        if date == nil {
            isoFormatter.formatOptions = [.withInternetDateTime]
            date = isoFormatter.date(from: raw)
        }
        
        if date == nil {
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            date = df.date(from: raw)
        }
        
        if date == nil {
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            date = df.date(from: raw)
        }
        
        guard let date = date else {
            return raw
        }
        
        switch period {
        case .day:
            df.dateFormat = "HH:mm"
            return df.string(from: date)
        case .week:
            df.dateFormat = "E"
            return df.string(from: date)
        case .month:
            df.dateFormat = "d"
            return df.string(from: date)
        case .year:
            df.dateFormat = "MMM"
            return df.string(from: date)
        }
    }
        
    private func fetchData() async {
        chart = .loading
        do {
            let response = try await core.queryWidgetData(widget: widget, for: selectedPeriod)
            await core.preloadDictionaries(for: response)
            chart = .success(response)
        } catch {
            chart = .error(error)
        }
    }
}
