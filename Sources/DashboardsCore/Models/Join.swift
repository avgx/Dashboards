import Foundation

public struct Join: Codable {
    var alias: String?
    var conditions: [Condition]?
    var query: String?
    var table: String?
    var type: String?
}
