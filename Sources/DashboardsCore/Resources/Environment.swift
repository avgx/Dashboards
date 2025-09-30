import Foundation

public struct Environment {
    public static func get(_ key: String, defaultValue: String? = nil) -> String {
        if let value = ProcessInfo.processInfo.environment[key] {
            return value
        }
        if let defaultValue = defaultValue {
            return defaultValue
        }
        fatalError("Missing environment variable: \(key)")
    }
}
