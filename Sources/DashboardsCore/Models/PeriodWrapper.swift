import Foundation

public struct PeriodWrapper: Codable, Sendable {
    public var type: Period?
    public let from: String?
    public let to: String?
    public let timeZone: String?
    
    public init(type: Period, from: String? = nil, to: String? = nil, timeZone: String? = nil) {
        self.type = type
        self.from = from
        self.to = to
        self.timeZone = timeZone
    }
    
    enum CodingKeys: String, CodingKey {
        case type, from, to
        case timeZone = "timeZone"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(from, forKey: .from)
        try container.encodeIfPresent(to, forKey: .to)
        try container.encodeIfPresent(timeZone, forKey: .timeZone)
    }
}
