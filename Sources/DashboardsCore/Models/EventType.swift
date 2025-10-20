import Foundation

public enum EventType: String, Codable {
    case dictionary
    case set
    case string
    case number
    case datetime
    case json
}
