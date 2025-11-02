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
    
    public init(compare: String? = nil, delta: Int = 0, result: [[String: AnyCodable]]) {
        self.compare = compare
        self.delta = delta
        self.result = result
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
    
    /// Ключи для таблицы, отсортированные правильно (count в конце)
    public var orderedKeys: [String] {
        let keys = allKeys
        let countKeys = keys.filter { $0.lowercased() == "@count" || $0.lowercased() == "count" }
        let otherKeys = keys.filter { $0.lowercased() != "@count" && $0.lowercased() != "count" }
        return otherKeys + countKeys
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
    
    /// Проверяет, является ли ключ датой/временем
    public func isDateKey(_ key: String) -> Bool {
        let lowercased = key.lowercased()
        return lowercased.contains("date") || 
               lowercased.contains("time") || 
               lowercased.contains("hour") || 
               lowercased.contains("month") ||
               lowercased.contains("datetime")
    }
    
    /// Форматирует значение даты для таблиц (dd.MM.yyyy)
    public func formatDateValue(_ rawValue: String) -> String? {
        guard let date = Self.parseDate(from: rawValue) else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    /// Форматирует значение даты/времени для donut chart (dd.MM.yyyy HH:mm:ss если есть время, иначе dd.MM.yyyy)
    public func formatDateTimeValue(_ rawValue: String) -> String? {
        guard let date = Self.parseDate(from: rawValue) else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        
        if rawValue.contains("T") {
            if let timePart = rawValue.components(separatedBy: "T").last?
                .components(separatedBy: ".").first?
                .components(separatedBy: "Z").first {
                let timeComponents = timePart.components(separatedBy: ":")
                if timeComponents.count >= 3 {
                    formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
                } else if timeComponents.count >= 2 {
                    formatter.dateFormat = "dd.MM.yyyy HH:mm"
                } else {
                    formatter.dateFormat = "dd.MM.yyyy HH:mm"
                }
            } else {
                formatter.dateFormat = "dd.MM.yyyy HH:mm"
            }
        } else {
            formatter.dateFormat = "dd.MM.yyyy"
        }
        
        return formatter.string(from: date)
    }
    
    /// Парсит дату из строки в различных форматах ISO8601
    public static func parseDate(from string: String) -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withTimeZone]
        if let date = isoFormatter.date(from: string) {
            return date
        }
        
        isoFormatter.formatOptions = [.withInternetDateTime]
        if let date = isoFormatter.date(from: string) {
            return date
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd"
        ]
        
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: string) {
                return date
            }
        }
        
        return nil
    }
}
