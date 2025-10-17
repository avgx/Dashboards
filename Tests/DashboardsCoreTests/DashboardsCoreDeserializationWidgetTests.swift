import Testing
import Foundation
@testable import DashboardsCore

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
