import Foundation

public struct CommonFilterValue: Codable, Sendable {
    public let fields: [String]
    public let period: PeriodWrapper?
    public let clauses: [Clause]
    public let periods: [String]?
    public let quickFilters: [String: AnyCodable]?
    public let customFieldsNames: [String: AnyCodable]?

    enum CodingKeys: String, CodingKey {
        case fields, period, clauses, periods, quickFilters, customFieldsNames
    }
}
