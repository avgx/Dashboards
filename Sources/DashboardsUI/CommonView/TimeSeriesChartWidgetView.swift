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
        ScrollView {
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
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("All")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(totalValue)
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(.purple.opacity(0.9))
                    
                    Group {
                        if case .success(let response) = chart,
                           let yearMonth = getYearMonthLabel(for: response, period: selectedPeriod) {
                            Text(yearMonth)
                                .font(.headline)
                                .foregroundColor(.black.opacity(0.8))
                        } else {
                            Text(periodLabel)
                                .font(.headline)
                                .foregroundColor(.black.opacity(0.8))
                        }
                    }
                    .padding(.bottom, 4)
                }
                
                content
                    .frame(height: 260)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 4)
        .task(id: refresh) { await fetchData() }
        .animation(.easeInOut, value: chart)
    }
        
    private var totalValue: String {
        if case .success(let response) = chart,
           let firstRow = response.result.first {
            let result = response.result
            
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
                let result = response.result
                if !result.isEmpty {
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
                        EmptyView(message: "No data available...")
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
                                            .rotationEffect(.degrees(-90))
                                            .frame(width: 40, alignment: .leading)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    EmptyView(message: "No data available...")
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
        guard let date = QueryResponse.parseDate(from: raw) else {
            return raw
        }
        
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        
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
    
    private func getYearMonthLabel(for response: QueryResponse, period: PeriodTimeSeries) -> String? {
        guard period == .month else {
            return nil
        }
        
        let result = response.result
        guard !result.isEmpty else {
            return nil
        }
        
        let firstRow = result.first!
        let xKey = firstRow.keys.first(where: {
            $0.lowercased().contains("time") || $0.lowercased().contains("date")
        }) ?? ""
        
        guard !xKey.isEmpty else { return nil }
        
        let dates = result.compactMap { row -> Date? in
            guard let raw = row[xKey]?.stringValue else { return nil }
            return QueryResponse.parseDate(from: raw)
        }
        
        guard let firstDate = dates.first, let lastDate = dates.last else { return nil }
        
        let calendar = Calendar.current
        let firstMonth = calendar.component(.month, from: firstDate)
        let firstYear = calendar.component(.year, from: firstDate)
        let lastMonth = calendar.component(.month, from: lastDate)
        let lastYear = calendar.component(.year, from: lastDate)
        
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateFormat = "MMMM yyyy"
        
        if firstMonth == lastMonth && firstYear == lastYear {
            return df.string(from: firstDate)
        }
        
        let firstStr = df.string(from: firstDate)
        let lastStr = df.string(from: lastDate)
        return "\(firstStr) - \(lastStr)"
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
