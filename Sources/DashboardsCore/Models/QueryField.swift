import Foundation

public struct QueryField: Codable, Sendable {
    public let field: String?
    public let alias: String?
    public let aggregationFunc: String?
}
