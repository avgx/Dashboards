import Foundation

public struct Descriptor: Codable {
    public let childs, fields: [String]?
    public let key: String
    public let tables: [Table]?
    public let type: ResultTypeEnum
    public let value: String?
    public let resultType: ResultTypeEnum?

    enum CodingKeys: String, CodingKey {
        case childs, fields, key, tables, type, value
        case resultType = "result_type"
    }
}
