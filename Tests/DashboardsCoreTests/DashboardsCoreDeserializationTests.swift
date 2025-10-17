import Testing
import Foundation
@testable import DashboardsCore

@Suite("DashboardsCore Deserialization Tests")
struct DashboardsCoreDeserializationTests {
    
    @Test func testDeserializeDashboardSimple() throws {
        let jsonData = bin_data(fromFile: "DashboardSimple", ext: "json")!
        /// Десериализация
        let decoded = try JSONDecoder().decode(Dashboard.self, from: jsonData)
        
        #expect(decoded.id == "0978ca92-7794-40c0-b887-4001ee4e79f4", "Dashboard ID should match")
        #expect(decoded.title == "все чеки по кредитным, дисконтным картам", "Dashboard title should match")
        #expect(decoded.serviceMode == true, "Dashboard serviceMode should match")
        #expect(decoded.owner == true, "Dashboard owner should match")
    }
    
}
