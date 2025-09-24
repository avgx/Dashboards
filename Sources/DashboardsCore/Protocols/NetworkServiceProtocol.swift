import Foundation

protocol NetworkServiceProtocol {
    func connect() async throws
    func dashboards() async throws -> [Dashboard]
}
