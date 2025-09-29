import Foundation

public struct WidgetFilter: Codable, Sendable {
    public let period: PeriodWrapper?
    public let clauses: [Clause]?

    enum CodingKeys: String, CodingKey {
        case period
        case clauses
    }
}
