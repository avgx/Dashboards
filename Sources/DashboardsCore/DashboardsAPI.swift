import Foundation
import Get


public enum DashboardsAPI {}

extension DashboardsAPI {
    
    public static func dashboards() -> Request<[Dashboard]> {
        Request(path: "/api/v1/ad-backend/users/my/dashboards")
    }
    
    public static func fields(lang: String) -> Request<[EventField]> {
        Request(path: "/api/v1/ad-dictionary/events/fields/", query: [("lang", lang)])
    }
    
    public static func tables(lang: String) -> Request<[EventTable]> {
        Request(path: "/api/v1/ad-dictionary/events/tables/", query: [("lang", lang)])
    }
    
    public static func connect() -> Request<Void> {
        Request(path: "")
    }
    
}
