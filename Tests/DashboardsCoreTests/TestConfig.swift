import Foundation

struct TestConfig {
    static let shared = TestConfig()
    
    let token: String
    let baseURL: URL
    
    private init() {
        /// Получение переменных из окружения
        self.baseURL = URL(string: Environment.get("API", defaultValue: "https://my...cloud.com/"))!
        self.token = Environment.get("TOKEN", defaultValue: "eyJhbGciOiJIUzI1NiIsInR5cC...hG9o8ptyyqNOSenS3GXmnH8ag")
    }
}
