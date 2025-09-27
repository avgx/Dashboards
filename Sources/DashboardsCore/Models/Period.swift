import Foundation

public enum Period: String, Codable, Sendable {
    case forever = "forever"
    case last15_Minutes = "last_15_minutes"
    case last1_Hour = "last_1_hour"
    case last24_Hours = "last_24_hours"
    case last30_Days = "last_30_days"
    case last6_Month = "last_6_month"
    case thisMonth = "this_month"
    case thisWeek = "this_week"
    case thisYear = "this_year"
    case today = "today"
    case userdefined = "userdefined"
    case yesterday = "yesterday"
}

public struct PeriodWrapper: Codable, Sendable {
    public let type: Period
    public let from: String?
    public let to: String?

    public init(type: Period, from: String? = nil, to: String? = nil) {
        self.type = type
        self.from = from
        self.to = to
    }
}
