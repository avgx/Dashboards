import Foundation
import Get

class DefaultNetworkService: NetworkServiceProtocol {
    private let client: HttpClient5
    
    init(client: HttpClient5) {
        self.client = client
    }
    
    func connect() async throws {
        try await client.send(DashboardsAPI.connect())
    }
    
    func fetchDashboards() async throws -> Response<[Dashboard]> {
        try await client.send(DashboardsAPI.dashboards())
    }
    
    func fetchEventFields(lang: String) async throws -> Response<[EventField]> {
        try await client.send(DashboardsAPI.fields(lang: lang))
    }
    
    func fetchFieldValues(type: String, name: String, lang: String) async throws -> Response<FieldValues> {
        try await client.send(DashboardsAPI.fieldValues(type: type, name: name, lang: lang))
    }
    
    func fetchEventTables(lang: String) async throws -> Response<[EventTable]> {
        try await client.send(DashboardsAPI.tables(lang: lang))
    }
    
    func executeQuery(query: Query) async throws -> Response<QueryResponse> {
        try await client.send(DashboardsAPI.query(query: query))
    }
    
    func fetchShareToken() async throws -> Response<ShareToken> {
        try await client.send(DashboardsAPI.shareToken())
    }

}
