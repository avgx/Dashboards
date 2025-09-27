import Foundation

public enum Table: String, Codable {
    case acfaEvents = "acfa_events"
    case alerts = "alerts"
    case analyzerEvents = "analyzer_events"
    case auditEvents = "audit_events"
    case counterEvents = "counter_events"
    case events = "events"
    case none = "none"
    case posEvents = "pos_events"
    case psimEvents = "psim_events"
    case unitEvents = "unit_events"
}
