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

@Suite("DashboardsCore AnyCodable Integration Tests")
struct DashboardsCoreAnyCodableIntegrationTests {
    
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

@Suite("DashboardsCore Deserialization Widget Tests")
struct DashboardsCoreDeserializationWidgetTests {
    
    @Test func testDeserializeDashboardSimpleWith1Widget() throws {
        let jsonData = bin_data(fromFile: "DashboardSimpleWith1Widget", ext: "json")!
        let decoded = try JSONDecoder().decode(Dashboard.self, from: jsonData).widgets[0]
        
        #expect(decoded.id == "widget1", "Dashboard widgets id should match")
        #expect(decoded.isQL == false, "Dashboard widgets isQL should match")
        #expect(decoded.title == "Test 1", "Dashboard widgets title should match")
        #expect(decoded.widget == "EventsTable", "Dashboard widgets widget should match")
        #expect(decoded.ignoreCommonFilter == false, "Dashboard ignoreCommonFilter should match")
    }
    
    @Test func testDeserializationDashboardSimpleWithWidget1WithOutImportantFields() throws {
        let jsonData = bin_data(fromFile: "DashboardSimpleWith1WidgetWithoutImportantFields", ext: "json")!
        
        do {
            let decoded = try JSONDecoder().decode(Dashboard.self, from: jsonData).widgets[0]
            #expect(decoded.isQL, "Widget must have isQL")
            #expect(decoded.title.isEmpty == false, "Widget must have title")
            #expect(decoded.widget.isEmpty == false, "Widget must have widget type")
            #expect(decoded.ignoreCommonFilter, "Widget must have ignoreCommonFilter")
        } catch {
            #expect(true, "Deserialization failed as expected due to missing required fields: \(error)")
        }
    }
    
    @Test func testDeserializeDashboardSimpleWith1WidgetAndQuery() throws {
        let jsonData = bin_data(fromFile: "DashboardSimpleWith1WidgetAndQuery", ext: "json")!
        let decoded = try JSONDecoder().decode(Dashboard.self, from: jsonData).widgets[0]
        
        #expect(decoded.query?.view == "fields", "Dashboard widgets query view should match")
        #expect(decoded.query?.limit == 100, "Dashboard widgets query limit should match")
        #expect(decoded.query?.table == "pos_events", "Dashboard widgets query table should match")
    }
    
    @Test func testDeserializeDashboardSimpleWithCameraWidgetAndFiltes() throws {
        let jsonData = bin_data(fromFile: "DashboardSimpleWithCameraWidgetAndFilters", ext: "json")!
        let decoded = try JSONDecoder().decode(Dashboard.self, from: jsonData).widgets[0]
        
        #expect(decoded.id == "widget_camera", "Camera widget must be multiple")
        #expect(decoded.widget == "Camera", "Camera widget must be multiple")
        #expect(decoded.query?.filter?.period?.type?.rawValue == "today", "Camera widget must be multiple")
        
    }
    
    @Test func testDeserializeDashboardSimpleWithChartWidgetAndVizualization() throws {
        let jsonData = bin_data(fromFile: "DashboardSimpleWithChartWidgetAndVizualization", ext: "json")!
        let decoded = try JSONDecoder().decode(Dashboard.self, from: jsonData).widgets[0]
        
        #expect(decoded.id == "widget_chart", "Chart widget must be multiple")
        #expect(decoded.widget == "BarChart", "Chart widget must be multiple")
        #expect(decoded.query?.view == "aggregated", "Chart widget must be multiple")
        #expect(decoded.visualization != nil, "Chart widget must be multiple")
        #expect(decoded.visualization?.autoplay == false, "Chart widget must be multiple")
        #expect(decoded.visualization?.rowsPerPage == "15", "Chart widget must be multiple")
        #expect(decoded.visualization?.noDataFormat == "text", "Chart widget must be multiple")
        #expect(decoded.visualization?.archiveEnabled == false, "Chart widget must be multiple")
    }
    
    @Test func testDashboardSimpleWithMapWidgetAndVizualization() throws {
        let jsonData = bin_data(fromFile: "DashboardSimpleWithMapWidgetAndVizualization", ext: "json")!
        let decoded = try JSONDecoder().decode(Dashboard.self, from: jsonData).widgets[0]
        
        #expect(decoded.id == "widget_map", "Map widget must be multiple")
        #expect(decoded.widget == "Map", "Map widget must be multiple")
        #expect(decoded.visualization != nil, "Map widget must be multiple")
        #expect(decoded.visualization != nil, "Map widget must be multiple")
        #expect(decoded.visualization?.autoplay == false, "Map widget must be multiple")
        #expect(decoded.visualization?.rowsPerPage == "15", "Map widget must be multiple")
        #expect(decoded.visualization?.noDataFormat == "text", "Map widget must be multiple")
        #expect(decoded.visualization?.archiveEnabled == false, "Map widget must be multiple")
    }
    
    @Test func testDashboardSimpleWithTableWidgetWithQuery() throws {
        let jsonData = bin_data(fromFile: "DashboardSimpleWithTableWidgeAndQuery", ext: "json")!
        let decoded = try JSONDecoder().decode(Dashboard.self, from: jsonData).widgets[0]
        
        #expect(decoded.widget == "EventsTable", "Table widget must be multiple")
        #expect(decoded.query?.view == "fields", "Table widget must be multiple")
        #expect(decoded.query?.table == "pos_events", "Table widget must be multiple")
        #expect(decoded.query?.fields[0].field == "pos.event.document", "Table widget must be multiple")
        #expect(decoded.query?.fields[1].field == "time.datetime", "Table widget must be multiple")
        #expect(decoded.query?.fields[2].field == "pos.event.cashier", "Table widget must be multiple")
        #expect(decoded.query?.filter?.period?.type?.rawValue == "today", "Table widget must be multiple")
    }
}

@Suite("DashboardsCore Query Tests")
struct DashboardsCoreQueryBuildetTests {
    
    @Test func testQueryBuilder() async throws {
        let jsonData = bin_data(fromFile: "QueryBuilder", ext: "json")!
        let decoded = try JSONDecoder().decode(WidgetQuery.self, from: jsonData)
        
        let query = QueryBuilder.build(from: decoded)
        
        #expect(query.view == "fields", "Query view should be 'fields'")
        #expect(query.table == "events", "Query table should be 'events'")
        #expect(query.fields?[0].field == "time.datetime", "Query should have 3 fields")
        #expect(query.fields?.first?.field == "time.datetime", "First field should be 'time.datetime'")
        #expect(query.orderBy?.first?.field == "time.datetime", "OrderBy field should be 'time.datetime'")
        #expect(query.distinctOn?.first?.field == "time.datetime", "DistinctOn first field should be 'time.datetime'")
        #expect(query.filter?.period?.from == "2025-04-18T09:15:00.000Z", "Filter period 'from' should match")
        #expect(query.filter?.period?.to == "2025-04-18T09:20:00.000Z", "Filter period 'to' should match")
        #expect(query.filter?.period?.type?.rawValue == "forever", "Filter period type should be 'forever'")
    }
    
    @Test func testQueryResponseSimpleWithTableWidget() throws {
        let jsonData = bin_data(fromFile: "QueryResponseSimpleWithTableWidget", ext: "json")!
        let decoded = try JSONDecoder().decode(QueryResponse.self, from: jsonData)
        
        #expect(decoded.compare == nil, "Query respone can be multiple")
        #expect(decoded.delta == 0, "Query respone can be multiple")
        #expect(decoded.result.first?["camera.displayId"]?.value as! String == "11", "Query respone can be multiple")
        #expect(decoded.result.first?["camera.group"]?.value as! String == "e2f20843-7ce5-d04c-8a4f-826e8b16d39c", "Query respone can be multiple")
        #expect(decoded.result.first?["camera.name"]?.value as! String == "паркинг 1", "Query respone can be multiple")
        #expect(decoded.result.first?["time.date"]?.value as! String == "2025-10-04T00:00:00Z", "Query respone can be multiple")
    }
    
    @Test func testQueryResponseSimpleWithAggregationWidget() throws {
        let jsonData = bin_data(fromFile: "QueryResponseSimpleWithAggregationWidget", ext: "json")!
        let decoded = try JSONDecoder().decode(QueryResponse.self, from: jsonData)
        
        #expect(decoded.compare == nil, "Query respone can be multiple")
        #expect(decoded.delta == 0, "Query respone can be multiple")
        #expect(decoded.result.first?["camera"]?.value as! String == "DESKTOP-UJ07PTL/DeviceIpint.11/SourceEndpoint.video:0:0", "Query respone can be multiple")
        #expect(decoded.result.first?["count"]?.value as! Int == 9946, "Query respone can be multiple")
    }
    
    @Test func testQueryResponseSimpleWithCounterWidget() throws {
        let jsonData = bin_data(fromFile: "QueryResponseSimpleWithCounterWidget", ext: "json")!
        let decoded = try JSONDecoder().decode(QueryResponse.self, from: jsonData)
        
        #expect(decoded.compare == nil, "Query respone can be multiple")
        #expect(decoded.delta == 0, "Query respone can be multiple")
        #expect(decoded.result.first?["count"]?.value as! Int == 20430, "Query respone can be multiple")
    }
    
    @Test func testQueryResponseSimpleWithBatWidget() throws {
        let jsonData = bin_data(fromFile: "QueryResponseSimpleWithBatWidget", ext: "json")!
        let decoded = try JSONDecoder().decode(QueryResponse.self, from: jsonData)
        
        #expect(decoded.compare == nil, "Query respone can be multiple")
        #expect(decoded.delta == 0, "Query respone can be multiple")
        #expect(decoded.result.first?["camera"]?.value as! String == "DESKTOP-UJ07PTL/DeviceIpint.11/SourceEndpoint.video:0:0", "Query respone can be multiple")
        #expect(decoded.result.first?["count"]?.value as! Int == 637, "Query respone can be multiple")
        #expect(decoded.result.first?["datetime.hour"]?.value as! String == "2025-10-04T01:00:00Z", "Query respone can be multiple")
        #expect(decoded.result.first?["time.date"]?.value as! String == "2025-10-04T00:00:00Z", "Query respone can be multiple")
        #expect(decoded.result.first?["time.hour"]?.value as! Int == 1, "Query respone can be multiple")
    }
}

