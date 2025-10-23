import Foundation

public struct EventTable: Codable, Equatable, Hashable {
    public let description: String
    public let name: String
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}
