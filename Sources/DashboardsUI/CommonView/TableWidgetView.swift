import SwiftUI
import DashboardsCore

@available(iOS 17.0, *)
struct TableWidgetView: View {
    @EnvironmentObject private var core: DashboardsCore
    @EnvironmentObject private var runtime: DashboardRuntime
    
    let widget: DashbordWidget
    @State private var table: Resource<QueryResponse> = .pending
    @State private var refresh = UUID()
    @State private var fontScale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(widget.title)
                    .font(.headline)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button {
                        fontScale = max(0.7, fontScale - 0.1)
                    } label: {
                        Image(systemName: "textformat.size.smaller")
                            .font(.system(size: 14))
                    }
                    .buttonStyle(.borderless)
                    
                    Divider().frame(height: 16)
                    
                    Button {
                        fontScale = min(1.4, fontScale + 0.1)
                        }
                    label: {
                        Image(systemName: "textformat.size.larger")
                            .font(.system(size: 14))
                    }
                    .buttonStyle(.borderless)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .stroke(Color.accentColor.opacity(0.6), lineWidth: 1)
                        .background(Capsule().fill(Color.accentColor.opacity(0.1)))
                )
                .foregroundColor(.accentColor)
            }
            
            switch table {
            case .pending:
                Text("?").frame(maxWidth: .infinity)
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
        .cornerRadius(16)
        .shadow(radius: 1)
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
        let keys = response.allKeys.prefix(4)
        
        if rows.isEmpty {
            Text("Нет данных")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, minHeight: 100)
        } else {
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    HStack(spacing: 0) {
                        ForEach(keys, id: \.self) { key in
                            Text(key)
                                .font(.system(size: 12 * fontScale, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .padding(.horizontal, 8)
                                .background(Color.accentColor.opacity(0.9))
                        }
                    }
                    .background(.ultraThinMaterial)
                    
                    ForEach(rows.indices, id: \.self) { i in
                        HStack(spacing: 0) {
                            ForEach(keys, id: \.self) { key in
                                Text(rows[i][key]?.stringValue ?? "—")
                                    .font(.system(size: 12 * fontScale))
                                    .foregroundColor(.primary)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.6)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(8)
                            }
                        }
                        .background(i % 2 == 0 ? Color(.systemGray6) : Color.clear)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .frame(maxHeight: 280)
            .animation(.default, value: fontScale)
        }
    }
}
