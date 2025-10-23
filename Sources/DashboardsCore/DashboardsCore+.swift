import Foundation
import Get

/// Helper methods for auth.
extension DashboardsCore {
    public static func testToken(url: URL, token: String) async throws {
        let http = HttpClient5(baseURL: url, authorization: .bearer(token))
        _ = try await http.send(Request(path: "/api/v3/ac-backend/domains/groups"))
    }
    
    public static func login(url: URL, user: String, pass: String) async throws -> String {
        let http = HttpClient5(baseURL: url)
        let loginV3 = LoginV3(email: user, password: pass, locale: Locale.current.identifier)
        let auth = try await http.send(Self.loginV3(loginV3))
        
        guard let token = auth.value.accessToken else {
            throw URLError(.badServerResponse)
        }
        return token
    }
    
    public static func loginV3(_ body: LoginV3) -> Request<AuthV3> {
        Request(path: "/api/v3/ac-backend/users/login", method: .post, body: body)
    }
    
    public struct LoginV3: Codable {
        public let clientId: String // uuid,
        public let email: String
        public let password: String
        public let locale: String //locale
        
        public init(email: String, password: String, locale: String) {
            self.clientId = "desktop.vms.client"
            self.email = email
            self.password = password
            self.locale = locale
        }
    }
    
    public struct AuthV3 : Codable, Sendable {
        public let accessToken: String?
        public let refreshToken: String?
        public let warning: String?
        
        public let code: Int?
        public let description: String?
        public let key: String?
        public let message: String?
    }
}
