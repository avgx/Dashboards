import SwiftUI
import Charts
import DashboardsCore

@available(iOS 17.0, *)
struct SummaryCardView: View {
    @EnvironmentObject private var core: DashboardsCore
    
    let widget: DashbordWidget
    
    @State private var data: Resource<QueryResponse> = .pending
    @State private var refresh = UUID()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack {
                Text(widget.title)
                    .font(.subheadline)
                    .foregroundStyle(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundStyle(.green)
            }
            
            Divider()
            
            Text("Today")
                .font(.subheadline)
                .foregroundStyle(.gray)
            
            if case .success(let response) = data,
               let totalValue = getTotalValue(from: response) {
                Text(totalValue)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.purple)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else if case .loading = data {
                Text("...")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.purple.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("0")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.purple)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if case .success(let response) = data {
                miniChart()
            } else {
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 50)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 200, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.secondarySystemBackground))
        )
        .task(id: refresh) {
            await loadData()
        }
    }
    
    private func loadData() async {
        data = .loading
        do {
            let response = try await core.queryWidgetData(widget: widget, for: .day)
            await core.preloadDictionaries(for: response)
            data = .success(response)
        } catch {
            data = .error(error)
        }
    }
    
    private func getTotalValue(from response: QueryResponse) -> String? {
        let result = response.result
        guard let firstRow = result.first else { return nil }
        
        let xKey = firstRow.keys.first(where: {
            $0.lowercased().contains("time") || $0.lowercased().contains("date") || $0.lowercased().contains("hour")
        }) ?? ""
        
        let yKey = firstRow.keys.first(where: { key in
            guard key != xKey else { return false }
            return firstRow[key]?.doubleValue != nil
        })
        
        guard let yKey = yKey else { return nil }
        
        let total = result
            .compactMap { $0[yKey]?.doubleValue }
            .reduce(0, +)
        
        return NumberFormatter.localizedString(from: NSNumber(value: total), number: .decimal)
    }
    
    @ViewBuilder
    private func miniChart() -> some View {
        let barCount = 26
        let barWidth: CGFloat = 2
        let barHeight: CGFloat = 36
        let spacing: CGFloat = 4

        VStack(spacing: 6) {
            HStack(alignment: .center, spacing: spacing) {
                ForEach(0..<barCount, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: barWidth, height: barHeight)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 25) {
                Text("00")
                Text("06")
                Text("12")
                Text("18")
            }
            .font(.system(size: 10, weight: .medium))
            .foregroundStyle(.gray)
        }
        .padding(.top, 4)
        .padding(.bottom, 6)
        .frame(height: 60)
    }

}

