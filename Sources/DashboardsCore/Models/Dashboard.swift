import Foundation

public typealias Dashboards = [Dashboard]

import Foundation

public struct Dashboard: Codable, Identifiable, Sendable, Equatable {
    public let id: String
    public var title: String
    public let description: String?
    public let revision: String?
    public let tags: String?
    public let owner: Bool
    public let version: Int
    public let lang: String?
    public let serviceMode: Bool
    public let commonFilter: Bool?
    public let commonFilterValue: CommonFilterValue?
    public let layout: Layout?
    public var widgets: [Widget]
    public let style: [String: Data]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case revision
        case tags
        case owner
        case version
        case lang
        case serviceMode
        case commonFilter
        case commonFilterValue
        case layout
        case widgets
        case style
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
}
