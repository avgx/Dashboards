import SwiftUI
import DashboardsCore

struct CounterWidgetView: View {
    @EnvironmentObject private var core: DashboardsCore
    @EnvironmentObject private var runtime: DashboardRuntime
    
    let widget: DashbordWidget

    @State var refresh = UUID()
    @State var count: Resource<Int> = .pending
    
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
            
            /// вариант 1
            switch count {
            case .pending:
                Text("?")
            case .loading:
                ProgressView()
            case .success(let value):
                Text("\(value)")
                    .font(.title2)
            case .error(let error):
                ErrorView(error: error, reloadAction: { refresh = UUID() })
            }
            
            Divider()
            
            /// вариант 2
            if let result = widgetBinding.wrappedValue {
                switch result {
                case .success(let response):
                    let value: AnyCodable? = response.result.first?["count"]
                    let count = value?.intValue ?? .min
                    Text("\(count)")
                        .font(.title2)
                case .error(let error):
                    ErrorView(error: error, reloadAction: { refresh = UUID() })
                case .loading:
                    ProgressView()
                case .pending:
                    Text("?")
                }
            } else {
                ProgressView()
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .task(id: refresh) {
            do {
                let response = try await core.queryWidgetData(widget: widget)
                
                guard let value = response.result.first?["count"] else {
                    throw DashboardsError.unexpectedResponse
                }
                guard value.isNumber else {
                    throw DashboardsError.unexpectedResponse
                }
                
                runtime.set(response: response, for: widget)
                
                count = .success(value.intValue!)
            } catch {
                runtime.set(error: error, for: widget)
            }
        }
    }
}
