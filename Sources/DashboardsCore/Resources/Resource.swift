public enum Resource<T : Equatable & Sendable>: Sendable {
    case pending
    case loading
    case success(T)
    case error(Error)
}

extension Resource {
    public var loading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    public var value: T? {
        if case .success(let value) = self {
            return value
        }
        return nil
    }
    
    public var error: Error? {
        if case .error(let error) = self {
            return error
        }
        return nil
    }
}

extension Resource: Equatable {
    var reflectedValue: String { String(reflecting: self) }
    
    // Explicitly implement the required `==` function
    // (The compiler will synthesize `!=` for us implicitly)
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.reflectedValue == rhs.reflectedValue
    }
}
