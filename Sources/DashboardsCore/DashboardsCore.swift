import Foundation
import Get

extension URL {
    static let invalid = URL(string: "https://")!
}

@MainActor
public class DashboardsCore: ObservableObject {
    public static let shared = DashboardsCore()
    
    @Published public private(set) var dashboards: Resource<[Dashboard]> = .pending
    @Published public private(set) var eventFields: Resource<[EventField]> = .pending
    @Published public private(set) var eventTables: Resource<[EventTable]> = .pending
    @Published public private(set) var widgetData: [String: Resource<QueryResponse>] = [:]
    @Published public private(set) var isConnected: Bool = false
    @Published public private(set) var isLoaded: Bool = false
    
    private var networkService: NetworkServiceProtocol
    
    private init() {
        self.networkService = DefaultNetworkService(client: HttpClient5(baseURL: .invalid, authorization: .bearer("")))
    }
    
    public func set(api: URL, token: String) {
        let client = HttpClient5(baseURL: api, authorization: .bearer(token))
        self.networkService = DefaultNetworkService(client: client)
    }
    
    public func connect() async throws {
        self.isConnected = false
        self.isLoaded = false
        
        self.dashboards = .pending
        self.eventFields = .pending
        self.eventTables = .pending
        
        
        do {
            try await networkService.connect()
            self.isConnected = true
            
            try await initialFetch()
            self.isLoaded = true
            
        } catch {
            self.isConnected = true
            self.isLoaded = true
            
            self.dashboards = .error(error)
            self.eventFields = .error(error)
            self.eventTables = .error(error)
            throw error
        }
    }
    
    public func retry() async throws{
        try await connect()
    }
    
    private func initialFetch() async throws {
        self.dashboards = .loading
        self.eventFields = .loading
        self.eventTables = .loading
        
        do {
            let dashboard = try await networkService.fetchDashboards()
            let fields = try await networkService.fetchEventFields(lang: "en")
            let tables = try await networkService.fetchEventTables(lang: "en")
            
            self.dashboards = .success(dashboard.value)
            self.eventFields = .success(fields.value)
            self.eventTables = .success(tables.value)
            /// Временный дебаг для проверки структуры encode dashboard
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let encodedData = try encoder.encode(dashboard.value.first)
            
            if let jsonString = String(data: encodedData, encoding: .utf8) {
                debugPrint("JSON: \(jsonString)")
            }
            
        } catch {
            self.isConnected = true
            self.isLoaded = true
            
            self.dashboards = .error(error)
            self.eventFields = .error(error)
            self.eventTables = .error(error)
            throw error
        }
    }
    
    public func loadWidgetData(widget: Widget) async {
        guard let widgetQuery = widget.query else { return }
        widgetData[widget.id] = .loading
        
        let query = QueryBuilder.build(from: widgetQuery)
        
        do {
            /// Временный дебаг для проверки структуры post запроса
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let encodedData = try encoder.encode(query)
            
            if let jsonString = String(data: encodedData, encoding: .utf8) {
                debugPrint("JSON: \(jsonString)")
            }
            
            let response = try await networkService.executeQuery(query: query)
            widgetData[widget.id] = .success(response.value)
        } catch {
            widgetData[widget.id] = .error(error)
        }
    }
    
}
