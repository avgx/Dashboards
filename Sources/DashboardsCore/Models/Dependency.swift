import Foundation

public struct Dependency: Codable, Sendable {
    public let id: String
    public let field: String
    public let translation: String?

    enum CodingKeys: String, CodingKey {
        case id
        case field
        case translation
    }
}
