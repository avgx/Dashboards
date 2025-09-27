import Foundation

public struct Descriptor: Codable {
    let childs, fields: [String]?
    let key: String
    let tables: [Table]?
    let type: ResultTypeEnum
    let value: String?
    let resultType: ResultTypeEnum?

    enum CodingKeys: String, CodingKey {
        case childs, fields, key, tables, type, value
        case resultType = "result_type"
    }
}
