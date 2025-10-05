import Foundation

public struct WidgetQuery: Codable, Sendable {
    public let view: String
    public let limit: Int?
    public let table: String?
    public let fields: [QueryField]
    public let filter: WidgetFilter?
    public let groupBy: [String]?
    public let orderBy: [OrderBy]?
    public let distinctOn: [QueryField]?
    public let joinSubquery: JoinSubquery?

    enum CodingKeys: String, CodingKey {
        case view, limit, table, fields, filter, groupBy, orderBy, distinctOn, joinSubquery
    }
}
