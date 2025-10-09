import Foundation

public struct JoinTable: Codable {
    var conditions: [JoinCondition]?
    var joinType: String?
    var table: String?
}

