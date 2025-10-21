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
    @Published public private(set) var isConnected: Bool = false
    @Published public private(set) var isLoaded: Bool = false
    @Published public private(set) var fieldDictionaries: [String: [String: String]] = [:]
    
    private var baseURL: URL = .invalid
    private var networkService: NetworkServiceProtocol
    
    private init() {
        self.networkService = DefaultNetworkService(client: HttpClient5(baseURL: .invalid, authorization: .bearer("")))
    }
    
    public func set(api: URL, token: String) {
        self.baseURL = api
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
            
        } catch {
            self.isConnected = true
            self.isLoaded = true
            
            self.dashboards = .error(error)
            self.eventFields = .error(error)
            self.eventTables = .error(error)
            throw error
        }
    }
    
    public func queryWidgetData(widget: Widget) async throws -> QueryResponse {
        guard let widgetQuery = widget.query else { throw DashboardsError.missingQuery }
        
        let query = QueryBuilder.build(from: widgetQuery)
        
        let response = try await networkService.executeQuery(query: query)
        return response.value
    }
    
    public func getFieldDictionary(
        type: String,
        fieldName: String,
        lang: String = "ru"
    ) async throws -> [String: String] {
        if let cached = fieldDictionaries[fieldName] {
            return cached
        }
        
        let fieldValues = try await fetchFieldValues(type: type, fieldName: fieldName, lang: lang)
        
        let dict = fieldValues.result.reduce(into: [String: String]()) { acc, item in
            acc[item.key] = item.translation ?? item.value ?? item.key
        }
        
        fieldDictionaries[fieldName] = dict
        
        return dict
    }
    
    private func fetchFieldValues(type: String, fieldName: String, lang: String = "en") async throws -> FieldValues {
        let response = try await networkService.fetchFieldValues(type: type, name: fieldName, lang: lang)
        return response.value
    }
    
    public func makeWebDashboardURL(for dashboard: Dashboard) async throws -> URL {
        let response = try await networkService.fetchShareToken()
        let token = response.value.shareToken
        
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }
        
        components.path = "/dd/shared/\(dashboard.id)"
        components.queryItems = [
            URLQueryItem(name: "shareToken", value: token)
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        return url
    }
}
