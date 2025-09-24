import Foundation
import Get

class DefaultNetworkService: NetworkServiceProtocol {
    
    private var http: HttpClient5?
    
    init(baseURL: URL, token: String) {
        self.http = HttpClient5(baseURL: baseURL, authorization: .bearer(token))
    }
    
    func connect() async throws {
        _ = try await http?.send(DashboardsAPI.connect())
    }
    
    func dashboards() async throws -> [Dashboard] {
        guard let http = http else {
            throw DashboardsError.notConnected
        }
        return try await http.send(DashboardsAPI.dashboards()).value
    }
    
}
