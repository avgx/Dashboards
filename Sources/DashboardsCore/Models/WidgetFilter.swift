import Foundation

public struct WidgetFilter: Codable, Sendable {
    public var period: PeriodWrapper?
    public let clauses: [Clause]?
    public let version: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case period
        case clauses
        case version
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(period, forKey: .period)
        try container.encodeIfPresent(clauses, forKey: .clauses)
        try container.encode(version, forKey: .version)
    }
}

