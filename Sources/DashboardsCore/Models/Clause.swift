import Foundation

public struct Clause: Codable, Sendable {
    public let id: String?
    public let op: String?
    public let type: String?
    public let field: String?
    public let value: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case op
        case type
        case field
        case value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.op = try container.decodeIfPresent(String.self, forKey: .op)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.field = try container.decodeIfPresent(String.self, forKey: .field)
        do {
            if let valueArray = try? container.decode([String].self, forKey: .value) {
                self.value = valueArray
            } else if let valueString = try? container.decode(String.self, forKey: .value) {
                self.value = [valueString]
            } else if let valueInt = try? container.decode(Int.self, forKey: .value) {
                self.value = [String(valueInt)]
            } else if try container.decodeNil(forKey: .value) {
                self.value = []
            } else {
                throw DecodingError.dataCorruptedError(forKey: .value, in: container, debugDescription: "Value must be a String, an array of Strings, an Int, or null")
            }
        } catch {
            throw DecodingError.dataCorruptedError(forKey: .value, in: container, debugDescription: "Value decoding failed")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(op, forKey: .op)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(field, forKey: .field)
        try container.encodeIfPresent(value, forKey: .value)
    }
}
