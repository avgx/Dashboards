import Testing
import Foundation
@testable import DashboardsCore

@Test func testConnect() async throws {
    // Получение переменных окружения
    let token = Environment.get("TOKEN", defaultValue: "eyJhbGciOiJIUzI1NiIsInR5cC...hG9o8ptyyqNOSenS3GXmnH8ag")
    let baseURL = Environment.get("API", defaultValue: "https://my...cloud.com/")
            
    let core = await DashboardsCore.shared
    try await core.connect(api: URL(string: baseURL)!, token: token)
    #expect(true, "connection success")
}
