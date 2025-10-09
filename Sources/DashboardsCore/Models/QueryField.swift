import Foundation

public struct QueryField: Codable, Sendable {
    public var field: String?
    public var alias: String?
    public var aggregationFunc: String?
    public var prefix: String?
    public var expression: QueryExpression?
    public var builtinFunc: String?

    public init(
        field: String? = nil,
        alias: String? = nil,
        aggregationFunc: String? = nil,
        prefix: String? = nil,
        expression: QueryExpression? = nil,
        builtinFunc: String? = nil
    ) {
        self.field = field
        self.alias = alias
        self.aggregationFunc = aggregationFunc
        self.prefix = prefix
        self.expression = expression
        self.builtinFunc = builtinFunc
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.field = try container.decodeIfPresent(String.self, forKey: .field)
        self.alias = try container.decodeIfPresent(String.self, forKey: .alias)
        self.aggregationFunc = try container.decodeIfPresent(String.self, forKey: .aggregationFunc)
        self.prefix = try container.decodeIfPresent(String.self, forKey: .prefix)
        self.expression = try container.decodeIfPresent(QueryExpression.self, forKey: .expression)
        self.builtinFunc = try container.decodeIfPresent(String.self, forKey: .builtinFunc)
    }

    public enum CodingKeys: String, CodingKey {
        case field, alias, aggregationFunc, prefix, expression, builtinFunc
    }
}
