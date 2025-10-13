import Testing
import Foundation
@testable import DashboardsCore

@Suite("DashboardsCore AnyCodable Tests")
struct DashboardsCoreAnyCodableTests {
    
    @Test func testDecodeDashboardSimpleWithFilterWithAnyCodable() throws {
        let jsonData = bin_data(fromFile: "DashboardSimpleWithFilterWithAnyCodable", ext: "json")!
        let decoded = try JSONDecoder().decode(Dashboard.self, from: jsonData)
        /// Проверяем commonFilterValue
        let commonFilterValue = decoded.commonFilterValue
        #expect(commonFilterValue?.fields.contains("pos.event.cashier") == true)
        #expect(commonFilterValue?.period?.type?.rawValue == "this_month")
        /// Проверяем quickFilters
        guard let quickFilters = commonFilterValue?.quickFilters else {
            Issue.record("quickFilters отсутствует")
            return
        }
        
        if let filter = quickFilters["8LL7pEu6vo3CrIrUIo2N21HTLcvIs-B5CeCj"]?.value as? [String: Any] {
            #expect(filter["id"] as? String == "8LL7pEu6vo3CrIrUIo2N21HTLcvIs-B5CeCj")
            #expect(filter["op"] as? String == "eq")
            #expect(filter["field"] as? String == "pos.event.cashier")
            #expect((filter["value"] as? [String])?.first == "8369")
        } else {
            Issue.record("Не удалось декодировать фильтр 8LL7pEu6vo3CrIrUIo2N21HTLcvIs-B5CeCj")
        }
        
        if let FilterTwo = quickFilters["Vli7Gp-RbsK53NHtMk6fu7FV2pdeX4VDWIk5"]?.value as? [String: Any] {
            #expect(FilterTwo["id"] as? String == "Vli7Gp-RbsK53NHtMk6fu7FV2pdeX4VDWIk5")
            #expect(FilterTwo["op"] as? String == "eq")
            #expect(FilterTwo["field"] as? String == "pos.event.cashier")
            #expect((FilterTwo["value"] as? [String])?.first == "4760")
        } else {
            Issue.record("Не удалось декодировать фильтр Vli7Gp-RbsK53NHtMk6fu7FV2pdeX4VDWIk5")
        }
        /// Проверяем customFields
        let customFields = commonFilterValue?.customFieldsNames
        #expect(customFields?["cloud.domain"]?.value as? String == "АЗС")
        #expect(customFields?["pos.event.pos_name"]?.value as? String == "Касса")
        #expect(customFields?["pos.event.function_name"]?.value as? String == "Наименование события")
    }
    
}
