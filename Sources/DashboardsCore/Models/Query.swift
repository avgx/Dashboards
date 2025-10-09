import Foundation

public struct Query: Codable {
    public let view: String?
    public let limit: Int?
    public let table: String?
    public let fields: [QueryField]?
    public let filter: WidgetFilter?
    public let groupBy: [String]?
    public let orderBy: [OrderBy]?
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
}
