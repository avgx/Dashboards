import SwiftUI

/// Эта сущность отражает `вычисленное` состояние дашборда.
/// Тут мы не делаем сетевые вызовы. Только обрабатываем ответы с результатами
@MainActor
public class DashboardRuntime: ObservableObject {
    @Published public private(set) var widgetData: [String: Resource<QueryResponse>] = [:]

    public let dashboard: Dashboard

    public init(dashboard: Dashboard) {
        self.dashboard = dashboard
    }

    public func set(response: QueryResponse, for widget: DashbordWidget) {
        widgetData[widget.id] = .success(response)
    }
    
    public func set(error: Error, for widget: DashbordWidget) {
        widgetData[widget.id] = .error(error)
    }
}
