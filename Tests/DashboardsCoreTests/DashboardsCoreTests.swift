import Testing
import Foundation
@testable import DashboardsCore

@Suite("DashboardsCore Integration Tests")
struct DashboardsCoreSuite {
    
    @Test func testConnect() async throws {
        let core = await DashboardsCore.shared
        await core.set(api: TestConfig.shared.baseURL, token: TestConfig.shared.token)
        try await core.connect()
        await #expect(core.isConnected == true, "connection should succeed")
    }
    
    @Test func testFetchDashboards() async throws {
        let core = await DashboardsCore.shared
        await core.set(api: TestConfig.shared.baseURL, token: TestConfig.shared.token)
        try await core.connect()
        
        if let dashboards = await core.dashboards.value {
            #expect(dashboards.count > 0, "There should be dashboards")
            if let first = dashboards.first {
                #expect(first.title.isEmpty == false, "Dashboard title should not be empty")
            } else {
                #expect(Bool(false), "No dashboards returned")
            }
        }
    }
}
