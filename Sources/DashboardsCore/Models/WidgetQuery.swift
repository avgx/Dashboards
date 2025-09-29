import Foundation

public struct WidgetQuery: Codable, Sendable {
    public let view: String
    public let limit: Int?
    public let table: String?
    public let fields: [QueryField]
    public let filter: WidgetFilter?
    public let groupBy: [String]?
    public let orderBy: [OrderBy]?
    
    enum CodingKeys: String, CodingKey {
        case view
        case limit
        case table
        case fields
        case filter
        case groupBy
        case orderBy
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.view = try container.decode(String.self, forKey: .view)
        self.limit = try container.decodeIfPresent(Int.self, forKey: .limit)
        self.table = try container.decodeIfPresent(String.self, forKey: .table)
        self.fields = try container.decode([QueryField].self, forKey: .fields)
        self.filter = try container.decodeIfPresent(WidgetFilter.self, forKey: .filter)
        self.groupBy = try container.decodeIfPresent([String].self, forKey: .groupBy) ?? []
        self.orderBy = try container.decodeIfPresent([OrderBy].self, forKey: .orderBy) ?? [] 
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(view, forKey: .view)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(table, forKey: .table)
        try container.encode(fields, forKey: .fields)
        try container.encodeIfPresent(filter, forKey: .filter)
        try container.encodeIfPresent(groupBy, forKey: .groupBy)
        try container.encodeIfPresent(orderBy, forKey: .orderBy)
    }
}
