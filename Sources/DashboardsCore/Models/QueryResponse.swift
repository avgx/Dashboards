import Foundation

public struct QueryResponse: Decodable, Equatable {
    public let compare: String?
    public let delta: Int
    public let result: [[String: AnyCodable]]
    
    enum CodingKeys: String, CodingKey {
        case compare
        case delta
        case result
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.compare = try? container.decode(String.self, forKey: .compare)
        self.delta = (try? container.decode(Int.self, forKey: .delta)) ?? 0
        
        do {
            self.result = try container.decode([[String: AnyCodable]].self, forKey: .result)
        } catch {
            self.result = []
        }
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.compare == rhs.compare
    }
    
    /// Все ключи для таблицы 
    public var allKeys: [String] {
        let keys = result.flatMap { $0.keys }
        let unique = Array(Set(keys))
        return unique.sorted()
    }
    
    /// Первый ключ, похожий на дату/время
    public var firstDateKey: String? {
        allKeys.first(where: { $0.lowercased().contains("date") || $0.lowercased().contains("time") })
    }
    
    /// Первый числовой ключ
    public var firstNumericKey: String? {
        for row in result {
            for (key, value) in row {
                if value.isNumber { return key }
            }
        }
        return nil
    }
}
