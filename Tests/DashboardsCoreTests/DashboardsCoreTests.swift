import Testing
@testable import DashboardsCore

@Suite("DashboardsCore Integration Tests")
struct DashboardsCoreSuite {
    var core: DashboardsCoreProtocol
    
    init() async {
        let realService = DefaultNetworkService(baseURL: TestConfig.shared.baseURL, token: TestConfig.shared.token)
        self.core = await DashboardsCore(networkService: realService)
    }
    
    @Test func testConnect() async throws {
        try await core.connect(api: TestConfig.shared.baseURL, token: TestConfig.shared.token)
        #expect(core.isConnected == true, "connection should succeed")
    }
    
    @Test func testFetchDashboards() async throws {
        try await core.connect(api: TestConfig.shared.baseURL, token: TestConfig.shared.token)
        try await core.fetchDashboards()
        #expect(core.dashboards.count > 0, "fetch dashboards success")
        #expect(core.dashboards[0].title != "", "dashboard has title")
    }
}

