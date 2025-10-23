import Foundation

public struct Query: Codable {
    public let view: String?
    public let limit: Int?
    public let table: String?
    public var fields: [QueryField]?
    public var filter: WidgetFilter?
    public var groupBy: [String]?
    public var orderBy: [OrderBy]?
    public let distinctOn: [QueryField]?
    public let joinSubquery: JoinSubquery?

    public init(
        view: String? = nil,
        limit: Int? = nil,
        table: String? = nil,
        fields: [QueryField]? = nil,
        filter: WidgetFilter? = nil,
        groupBy: [String]? = nil,
        orderBy: [OrderBy]? = nil,
        distinctOn: [QueryField]? = nil,
        joinSubquery: JoinSubquery? = nil
    ) {
        self.view = view
        self.limit = limit
        self.table = table
        self.fields = fields
        self.filter = filter
        self.groupBy = groupBy
        self.orderBy = orderBy
        self.distinctOn = distinctOn
        self.joinSubquery = joinSubquery
    }

    enum CodingKeys: String, CodingKey {
        case view, limit, table, fields, filter, groupBy, orderBy, distinctOn, joinSubquery
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(view, forKey: .view)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(table, forKey: .table)
        try container.encodeIfPresent(fields, forKey: .fields)
        try container.encodeIfPresent(filter, forKey: .filter)
        try container.encodeIfPresent(groupBy, forKey: .groupBy)
        try container.encodeIfPresent(orderBy, forKey: .orderBy)
        try container.encodeIfPresent(distinctOn, forKey: .distinctOn)
        try container.encodeIfPresent(joinSubquery, forKey: .joinSubquery)
    }
}
