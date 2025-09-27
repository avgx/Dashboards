import Foundation

public struct LayoutItem: Codable, Sendable {
    public let h: Int
    public let w: Int
    public let x: Int?
    public let y: Int?
    public let i: String
    public let minH: Int?
    public let minW: Int?
    public let moved: Bool?
    public let isStatic: Bool?

    enum CodingKeys: String, CodingKey {
        case h
        case w
        case x
        case y
        case i
        case minH
        case minW
        case moved
        case isStatic = "static"
    }
}
