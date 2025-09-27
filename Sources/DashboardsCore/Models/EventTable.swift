import Foundation

public struct EventTable: Codable, Equatable {
    let description: String
    let name: String
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}
