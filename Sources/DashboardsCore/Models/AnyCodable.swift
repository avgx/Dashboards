import Foundation

public struct AnyCodable: Codable, Sendable {
    public let value: Any
    
    public init(_ value: Any) { self.value = value }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else if let arrayValue = try? container.decode([AnyCodable].self) {
            value = arrayValue.map { $0.value }
        } else if let dictValue = try? container.decode([String: AnyCodable].self) {
            value = dictValue.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Unsupported JSON value")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case let intValue as Int:
            try container.encode(intValue)
        case let doubleValue as Double:
            try container.encode(doubleValue)
        case let boolValue as Bool:
            try container.encode(boolValue)
        case let stringValue as String:
            try container.encode(stringValue)
        case let arrayValue as [Any]:
            try container.encode(arrayValue.map { AnyCodable($0) })
        case let dictValue as [String: Any]:
            try container.encode(dictValue.mapValues { AnyCodable($0) })
        default:
            throw EncodingError.invalidValue(value,
                                             EncodingError.Context(
                                                codingPath: container.codingPath,
                                                debugDescription: "Unsupported JSON value"
                                             ))
        }
    }
}

extension AnyCodable {
    /// получение числа как Double
    public var doubleValue: Double? {
        switch value {
        case let int as Int:
            return Double(int)
        case let double as Double:
            return double
        case let string as String:
            return Double(string)
        default:
            return nil
        }
    }
    
    /// получение числа как Int
    public var intValue: Int? {
        switch value {
        case let int as Int:
            return int
        case let double as Double:
            return Int(double)
        case let string as String:
            return Int(string)
        default:
            return nil
        }
    }
    
    /// хелпер для проверки, содержит ли значение число
    public var isNumber: Bool {
        return doubleValue != nil
    }
}
