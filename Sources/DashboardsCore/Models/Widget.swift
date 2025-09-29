import Foundation

public struct Widget: Codable, Identifiable, Sendable {
    public let id: String
    public var title: String
    public let description: String?
    public let widget: String
    public let isQL: Bool
    public let query: WidgetQuery?
    public let style: Data?
    public let visualization: Visualization?
    public let dependOn: [Dependency]?
    public let ignoreCommonFilter: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case widget
        case isQL
        case query
        case style
        case visualization
        case dependOn
        case ignoreCommonFilter
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.widget = try container.decode(String.self, forKey: .widget)
        self.isQL = try container.decode(Bool.self, forKey: .isQL)
        self.query = try container.decodeIfPresent(WidgetQuery.self, forKey: .query)
        do {
            let styleData = try container.decodeIfPresent(Data.self, forKey: .style)
            if styleData == nil {
                self.style = nil
            } else {
                if let jsonObject = try? JSONSerialization.jsonObject(with: styleData!, options: []),
                   let _ = jsonObject as? [String: Any] {
                    self.style = styleData
                } else {
                    self.style = nil
                }
            }
        } catch {
            self.style = nil
        }
        self.visualization = try container.decodeIfPresent(Visualization.self, forKey: .visualization)
        self.dependOn = try container.decodeIfPresent([Dependency].self, forKey: .dependOn)
        self.ignoreCommonFilter = try container.decode(Bool.self, forKey: .ignoreCommonFilter)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(widget, forKey: .widget)
        try container.encode(isQL, forKey: .isQL)
        try container.encodeIfPresent(query, forKey: .query)
        try container.encodeIfPresent(style, forKey: .style)
        try container.encodeIfPresent(visualization, forKey: .visualization)
        try container.encodeIfPresent(dependOn, forKey: .dependOn)
        try container.encode(ignoreCommonFilter, forKey: .ignoreCommonFilter)
    }
}
