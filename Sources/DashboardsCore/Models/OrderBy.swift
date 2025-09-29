import Foundation

public struct OrderBy: Codable, Sendable {
    public let field: String
    public let desc: Bool?
}
