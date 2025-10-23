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
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 1)
        .task(id: refresh) {
            do {
                let response = try await core.queryWidgetData(widget: widget)
                
                guard let firstRow = response.result.first else {
                    throw DashboardsError.unexpectedResponse
                }
                
                let valueKey = firstRow.keys.first(where: { key in
                    firstRow[key]?.doubleValue != nil
                })
                
                guard let valueKey = valueKey,
                      let value = firstRow[valueKey],
                      value.isNumber else {
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
