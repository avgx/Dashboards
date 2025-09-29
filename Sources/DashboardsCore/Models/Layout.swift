import Foundation

public struct Layout: Codable, Sendable {
    public let mobile: [LayoutItem]?
    public let desktop: [LayoutItem]?
    public let panels: [String]?

    enum CodingKeys: String, CodingKey {
        case mobile
        case desktop
        case panels
    }
}
