import SwiftUI
import DashboardsCore

struct TableWidgetView: View {
    @EnvironmentObject private var core: DashboardsCore
    @EnvironmentObject private var runtime: DashboardRuntime

    let widget: DashbordWidget

    @State private var refresh = UUID()
    @State private var table: Resource<QueryResponse> = .pending

    private var widgetBinding: Binding<Resource<QueryResponse>?> {
        Binding(
            get: { runtime.widgetData[widget.id] },
            set: { _ in } // read-only
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(widget.title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            switch table {
            case .pending:
                Text("?")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.secondary)
            case .loading:
                ProgressView()
            case .success(let response):
                buildTable(from: response)
            case .error(let error):
                ErrorView(error: error, reloadAction: { refresh = UUID() })
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .task(id: refresh) {
            await loadData()
        }
    }

    // MARK: - Загрузка данных
    private func loadData() async {
        table = .loading
        do {
            let response = try await core.queryWidgetData(widget: widget)
            runtime.set(response: response, for: widget)
            table = .success(response)
        } catch {
            runtime.set(error: error, for: widget)
            table = .error(error)
        }
    }

    // MARK: - Построение таблицы
    @ViewBuilder
    private func buildTable(from response: QueryResponse) -> some View {
        let rows = response.result
        let keys = response.allKeys.filter { !$0.isEmpty }

        if rows.isEmpty {
            Text("Нет данных для таблицы")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, minHeight: 100)
        } else {
            ScrollView([.vertical, .horizontal]) {
                VStack(alignment: .leading, spacing: 0) {
                    // Заголовки
                    HStack {
                        ForEach(keys, id: \.self) { key in
                            Text(key)
                                .font(.subheadline.bold())
                                .frame(minWidth: 120, alignment: .leading)
                                .padding(.vertical, 4)
                        }
                    }
                    Divider()

                    // Данные
                    ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                        HStack {
                            ForEach(keys, id: \.self) { key in
                                let value = row[key]?.value ?? "-"
                                if let number = row[key]?.doubleValue {
                                    Text("\(Int(number))")
                                        .frame(minWidth: 120, alignment: .trailing)
                                } else if let string = value as? String {
                                    Text(string.isEmpty ? "-" : string)
                                        .frame(minWidth: 120, alignment: .leading)
                                } else {
                                    Text("\(value)")
                                        .frame(minWidth: 120, alignment: .leading)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                        .background(index.isMultiple(of: 2) ? Color.gray.opacity(0.08) : Color.clear)
                    }
                }
                .padding(.horizontal, 4)
            }
            .frame(maxHeight: 280)
        }
    }
}
