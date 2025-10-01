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
    
    private var networkService: NetworkServiceProtocol
    private(set) var lastAPI: URL?
    private(set) var lastToken: String?
    
    private init() {
        self.networkService = DefaultNetworkService(client: HttpClient5(baseURL: .invalid, authorization: .bearer("")))
    }
    
    public func connect(api: URL, token: String) async throws {
        self.lastAPI = api
        self.lastToken = token
        
        let client = HttpClient5(baseURL: api, authorization: .bearer(token))
        self.networkService = DefaultNetworkService(client: client)
        do {
            try await networkService.connect()
            self.isConnected = true
            
            try await initialFetch()
            self.isLoaded = true
        } catch {
            self.isConnected = false
            self.isLoaded = false
            
            self.dashboards = .error(error)
            self.eventFields = .error(error)
            self.eventTables = .error(error)
            throw error
        }
    }
    
    public func retry() async throws{
        guard let api = lastAPI, let token = lastToken else {
            throw DashboardsError.missingCredentials
        }
        try await connect(api: api, token: token)
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
            self.isConnected = false
            self.isLoaded = false
            
            self.dashboards = .error(error)
            self.eventFields = .error(error)
            self.eventTables = .error(error)
            throw error
        }
    }
}
