import Foundation

public protocol DashboardsCoreProtocol {
    var dashboards: [Dashboard] { get }
    var isConnected: Bool { get }
    
    func connect(api: URL, token: String) async throws
    func fetchDashboards() async throws
}
