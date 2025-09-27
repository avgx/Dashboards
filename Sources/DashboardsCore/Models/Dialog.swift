import Foundation

public struct Dialog: Codable, Sendable {
    public let layout: Layout?
    public let widgets: [Widget]?
}
