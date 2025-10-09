import SwiftUI
import DashboardsCore

struct ChartWidgetView: View {
    @EnvironmentObject private var core: DashboardsCore
    @EnvironmentObject private var runtime: DashboardRuntime
    
    let widget: DashbordWidget
    
    @State var refresh = UUID()
    @State private var chart: Resource<QueryResponse> = .pending
    
    private var widgetBinding: Binding<Resource<QueryResponse>?> {
        Binding(
            get: { runtime.widgetData[widget.id] },
            set: { _ in } // Read-only
        )
    }
    
    var body: some View {
        VStack {
            Text(widget.title)
                .font(.headline)
            
            switch chart {
            case .pending:
                Text("?")
                    .frame(maxWidth: .infinity)
            case .loading:
                ProgressView()
            case .success(let value):
                buildChart(from: value)
            case .error(let error):
                ErrorView(error: error, reloadAction: { refresh = UUID() })
            }
        }
        .padding()
        .frame(minHeight: 200, maxHeight: 260)
        .background(.ultraThinMaterial)
        .task(id: refresh) {
            do {
                let response = try await core.queryWidgetData(widget: widget)
                
                runtime.set(response: response, for: widget)
                
                chart = .success(response)
            } catch {
                runtime.set(error: error, for: widget)
            }
        }
    }
    
    @ViewBuilder
    private func buildChart(from response: QueryResponse) -> some View {
     

        let rows = response.result

        // X-ключ (время/дата или первый)
        let xKey = rows.first?.keys.first(where: { $0.contains("time") || $0.contains("date") }) ?? rows.first?.keys.first ?? ""

        // Y-ключ (первый числовой во всех строках)
        let yKey = rows.first(where: { row in
            row.values.contains { $0.isNumber }
        })?.first(where: { $0.value.isNumber })?.key

        let data: [(String, Double)] = rows.compactMap { row in
            guard let yKey = yKey, let yValue = row[yKey]?.doubleValue else {
                return nil
            }

            let xValue: String
            if let xAny = row[xKey] {
                xValue = xAny.value as? String ?? String(describing: xAny.value)
            } else {
                xValue = "-"
            }

            return (xValue, yValue)
        }

        if data.isEmpty {
            Text("Нет данных для графика")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, minHeight: 180)
        } else {
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                let maxY = data.map(\.1).max() ?? 1
                let minY = data.map(\.1).min() ?? 0

                ZStack {
                    Path { path in
                        for (index, point) in data.enumerated() {
                            let x = width * CGFloat(index) / CGFloat(data.count - 1)
                            let normalizedY = (point.1 - minY) / (maxY - minY)
                            let y = height * (1 - CGFloat(normalizedY))

                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(.blue, lineWidth: 2)

                    ForEach(Array(data.enumerated()), id: \.offset) { index, point in
                        let x = width * CGFloat(index) / CGFloat(data.count - 1)
                        let normalizedY = (point.1 - minY) / (maxY - minY)
                        let y = height * (1 - CGFloat(normalizedY))

                        Circle()
                            .fill(.blue)
                            .frame(width: 6, height: 6)
                            .position(x: x, y: y)

                        Text(point.0)
                            .font(.system(size: 10))
                            .rotationEffect(.degrees(-45))
                            .position(x: x, y: height + 10)
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 180)
        }
    }

}все равн опишет нету данных для графика и все 