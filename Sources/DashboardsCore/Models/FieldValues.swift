import Foundation

public struct FieldValues: Codable {
    public let result: [FieldValue]
    public let status: Int
    public let total: Int
}
