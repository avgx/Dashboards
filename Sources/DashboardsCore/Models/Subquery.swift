import Foundation

public struct Subquery: Codable {
    public let alias: String
    public let table: String
    public let fields: [QueryField]
    public let filter: WidgetFilter?
    public let orderBy: [OrderBy]?

    public init(
        alias: String,
        table: String,
        fields: [QueryField],
        filter: WidgetFilter? = nil,
        orderBy: [OrderBy]? = nil
    ) {
        self.alias = alias
        self.table = table
        self.fields = fields
        self.filter = filter
        self.orderBy = orderBy
    }
}
