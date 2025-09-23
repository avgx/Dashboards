import Foundation

extension URL {
    static let invalid = URL(string: "https://")!
}

@MainActor
public class DashboardsCore: ObservableObject {
    public static let shared = DashboardsCore()
    
    @Published public private(set) var api: URL = .invalid
    @Published public private(set) var token: String = ""
    @Published public private(set) var isConnected: Bool = false
    
    private init() {
        
    }
    
    public func connect(api: URL, token: String) async throws {
        var request = URLRequest(url: api)
        request.addValue("Bearer: \(token)", forHTTPHeaderField: "Authorization")
        let (_, httpResponse) = try await URLSession.shared.data(for: request)
        
        guard let response = httpResponse as? HTTPURLResponse else {
            throw DashboardsError.unknown
        }
        let statusCode = response.statusCode
        guard (200..<300).contains(statusCode) else {
            throw DashboardsError.invalidStatusCode
        }
            
        self.api = api
        self.token = token
        self.isConnected = true
    }
}
