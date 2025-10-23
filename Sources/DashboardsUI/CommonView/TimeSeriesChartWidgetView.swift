import SwiftUI
import Charts
import DashboardsCore

@available(iOS 17.0, *)
struct TimeSeriesChartWidgetView: View {
    @EnvironmentObject private var core: DashboardsCore
    @EnvironmentObject private var runtime: DashboardRuntime
    
    let widget: DashbordWidget
    
    @State private var selectedPeriod: PeriodTimeSeries = .day
    @State private var chart: Resource<QueryResponse> = .pending
    @State private var refresh = UUID()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(widget.title)
                    .font(.headline)
                Spacer()
                Picker("", selection: $selectedPeriod) {
                    ForEach(PeriodTimeSeries.allCases, id: \.self) { period in
                        Text(period.rawValue)
                            .tag(period)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 250)
                .onChange(of: selectedPeriod) { _ in
                    refresh = UUID()
                }
            }
            .padding(.bottom, 8)
            
            content
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 1)
        .task(id: refresh) {
            await fetchData()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch chart {
        case .pending:
            LoadingView(message: "Connecting...")
        case .loading:
            LoadingView(message: "Loading dashboards...")
        case .success(let response):
            if let result = response.result as? [[String: AnyCodable]] {
                let data: [(x: String, y: Double)] = result.compactMap { row in
                    let xValue = row["datetime.hour"]?.stringValue?.components(separatedBy: "T").first ??
                    row["time.date"]?.stringValue ??
                    row["time.month"]?.stringValue.map { String($0) }
                     let yValue = row["@count"] ?? row["count"]
                    guard let x = xValue,
                          let y = yValue?.doubleValue else {
                        return nil
                    }
                    return (x: x, y: y)
                }
                
                if data.isEmpty {
                    Text("Нет данных для отображения")
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .foregroundColor(.gray)
                } else {
                    Chart(data, id: \.x) { item in
                        BarMark(
                            x: .value("Hour", item.x),
                            y: .value("Count", item.y)
                        )
                    }
                    .frame(height: 240)
                }
            } else {
                Text("Некорректный формат данных")
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .foregroundColor(.red)
            }
        case .error(let error):
            Text("Ошибка: \(error.localizedDescription)")
                .foregroundColor(.red)
        }
    }
    
    private func fetchData() async {
        chart = .loading
        do {
            let response = try await core.queryWidgetData(widget: widget, for: selectedPeriod)
            chart = .success(response)
        } catch {
            chart = .error(error)
        }
    }
}
