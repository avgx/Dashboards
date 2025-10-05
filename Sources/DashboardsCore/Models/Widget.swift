import Foundation

public typealias DashbordWidget = Widget

public struct Widget: Codable, Identifiable, Sendable {
    public let id: String
    public var title: String
    public let description: String?
    public let widget: String
    public let isQL: Bool
    public let query: WidgetQuery?
    public let style: [String: AnyCodable]?
    public let visualization: Visualization?
    public let dependOn: [Dependency]?
    public let ignoreCommonFilter: Bool

    enum CodingKeys: String, CodingKey {
        case id, title, description, widget, isQL, query, style, visualization, dependOn, ignoreCommonFilter
    }

    public init(
        id: String,
        title: String,
        description: String? = nil,
        widget: String,
        isQL: Bool,
        query: WidgetQuery? = nil,
        style: [String: AnyCodable]? = nil,
        visualization: Visualization? = nil,
        dependOn: [Dependency]? = nil,
        ignoreCommonFilter: Bool
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.widget = widget
        self.isQL = isQL
        self.query = query
        self.style = style
        self.visualization = visualization
        self.dependOn = dependOn
        self.ignoreCommonFilter = ignoreCommonFilter
    }
}

