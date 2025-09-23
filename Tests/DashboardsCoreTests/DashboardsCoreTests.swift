import Testing
import Foundation
@testable import DashboardsCore

@Test func testConnect() async throws {
    let core = await DashboardsCore.shared
    try await core.connect(api: URL(string: "https://my...cloud.com/")!, token: "eyJhbGciOiJIUzI1NiIsInR5cC...hG9o8ptyyqNOSenS3GXmnH8ag")
    #expect(true, "connection success")
}
