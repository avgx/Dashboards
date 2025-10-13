import Testing
import Foundation
@testable import DashboardsCore

@Suite("DashboardsCore Query Tests")
struct DashboardsCoreQueryTests {
    
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

