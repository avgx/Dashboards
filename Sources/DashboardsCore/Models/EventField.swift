import Foundation

public struct EventField: Codable, Equatable {
    public let descriptor: Descriptor
    public let name: String
    public let translation: String
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}
