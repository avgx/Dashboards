import Foundation
import Get

extension URL {
    static let invalid = URL(string: "https://")!
}

@MainActor
public class DashboardsCore: DashboardsCoreProtocol, ObservableObject {
    public static let shared = DashboardsCore()
    
    @Published public private(set) var dashboards: [Dashboard] = []
    @Published public private(set) var isConnected: Bool = false
    
    private var networkService: NetworkServiceProtocol
    
    internal init(networkService: NetworkServiceProtocol = DefaultNetworkService(baseURL: URL(string: "https://default.com") ?? URL(string: "https://")!, token: "")) {
        self.networkService = networkService
    }
    
    public func connect(api: URL, token: String) async throws {
        self.networkService = DefaultNetworkService(baseURL: api, token: token)
        try await networkService.connect()
        self.isConnected = true
    }
    
    public func fetchDashboards() async throws {
        guard isConnected else {
            throw DashboardsError.notConnected
        }
        let dashboards = try await networkService.dashboards()
        self.dashboards = dashboards
    }
}
