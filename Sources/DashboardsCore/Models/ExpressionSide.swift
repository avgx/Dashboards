import Foundation

public struct ExpressionSide: Codable, Sendable {
    public let field: String?
    public let timeInterval: TimeIntervalValue?
}
