import Foundation

public struct FieldValue: Codable {
    public let key: String
    public let value: String?
    public let translation: String?

    enum CodingKeys: String, CodingKey {
        case key, value, translation
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let strKey = try? container.decode(String.self, forKey: .key) {
            key = strKey
        } else if let intKey = try? container.decode(Int.self, forKey: .key) {
            key = String(intKey)
        } else if let doubleKey = try? container.decode(Double.self, forKey: .key) {
            key = String(doubleKey)
        } else {
            key = ""
        }

        value = try? container.decodeIfPresent(String.self, forKey: .value)
        translation = try? container.decodeIfPresent(String.self, forKey: .translation)
    }
}
