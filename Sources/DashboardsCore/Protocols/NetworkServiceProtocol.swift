import Foundation
import Get

public protocol NetworkServiceProtocol {
    func connect() async throws
    func fetchDashboards() async throws -> Response<[Dashboard]>
    func fetchEventFields(lang: String) async throws -> Response<[EventField]>
    func fetchEventTables(lang: String) async throws -> Response<[EventTable]>
    func executeQuery(query: Query) async throws -> Response<QueryResponse>
}
