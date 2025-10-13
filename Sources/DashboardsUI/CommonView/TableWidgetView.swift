import SwiftUI
import DashboardsCore


struct TableWidgetView: View {
    @EnvironmentObject private var core: DashboardsCore
    @EnvironmentObject private var runtime: DashboardRuntime
    
    let widget: DashbordWidget
    
    @State private var refresh = UUID()
    @State private var table: Resource<QueryResponse> = .pending
    
    private var columnKeys: [String] {
        table.value?.allKeys ?? []
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(widget.title)
                .font(.headline)
            
            switch table {
            case .pending:
                Text("?")
                    .frame(maxWidth: .infinity)
            case .loading:
                ProgressView()
            case .success(let response):
                buildTable(from: response)
            case .error(let error):
                ErrorView(error: error, reloadAction: { refresh = UUID() })
            }
        }
        .padding()
        .frame(minHeight: 260, maxHeight: 300)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .task(id: refresh) {
            do {
                let response = try await core.queryWidgetData(widget: widget)
                runtime.set(response: response, for: widget)
                table = .success(response)
            } catch {
                runtime.set(error: error, for: widget)
                table = .error(error)
            }
        }
    }
    
    @ViewBuilder
    private func buildTable(from response: QueryResponse) -> some View {
        let rows = response.result
        
        if rows.isEmpty {
            Text("Нет данных для таблицы")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, minHeight: 100)
        } else {
            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        ForEach(columnKeys, id: \.self) { key in
                            Text(key)
                                .font(.caption)
                                .bold()
                                .frame(minWidth: 140, alignment: .leading)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.1))
                        }
                    }
                    
                    Divider()
                    
                    ForEach(Array(response.result.enumerated()), id: \.offset) { _, row in
                        HStack(spacing: 0) {
                            ForEach(columnKeys, id: \.self) { key in
                                let cellValue: String = {
                                    if let anyValue = row[key]?.value {
                                        return String(describing: anyValue)
                                    } else {
                                        return "-"
                                    }
                                }()
                                
                                Text(cellValue)
                                    .font(.caption)
                                    .frame(minWidth: 140, alignment: .leading)
                                    .padding(.vertical, 3)
                            }
                        }
                        Divider()
                    }
                }
            }
            .frame(minHeight: 260)
        }
    }
}
