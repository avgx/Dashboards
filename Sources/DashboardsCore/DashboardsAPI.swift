import Foundation
import Get


public enum DashboardsAPI {}

extension DashboardsAPI {
    
    public static func dashboards() -> Request<[Dashboard]> {
        Request(path: "/api/v1/ad-backend/users/my/dashboards")
    }
    
    public static func connect() -> Request<Void> {
        Request(path: "")
    }
    
}
