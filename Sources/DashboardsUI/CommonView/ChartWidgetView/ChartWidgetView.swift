import SwiftUI
import Charts
import DashboardsCore

@available(iOS 17.0, *)
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
                ChartContentView(widget: widget, response: value)
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
}
