import Foundation

public struct EventField: Codable, Equatable {
    let descriptor: Descriptor
    let name: String
    let translation: String
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}
