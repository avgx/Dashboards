import Foundation

public enum DashboardsError: Error {
    case unknown
    case invalidStatusCode
    case missingCredentials
    case notConnected
    case missingQuery
}
