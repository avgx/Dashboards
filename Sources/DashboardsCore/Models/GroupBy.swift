import Foundation

public struct GroupBy: Codable {
    public let field: String
    public let aggregationFunc: String?

    public init(field: String, aggregationFunc: String? = nil) {
        self.field = field
        self.aggregationFunc = aggregationFunc
    }
}
