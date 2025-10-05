import Foundation

public struct JoinSubquery: Codable {
    public let alias: String
    public let joinType: String
    public let subquery: Subquery
    public let conditions: [JoinCondition]

    public init(
        alias: String,
        joinType: String,
        subquery: Subquery,
        conditions: [JoinCondition]
    ) {
        self.alias = alias
        self.joinType = joinType
        self.subquery = subquery
        self.conditions = conditions
    }
}
