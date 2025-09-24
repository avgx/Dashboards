import Foundation

public typealias Dashboards = [Dashboard]

public struct Clause: Codable, Sendable {
    public let id: String?
    public let op: String?
    public let type: String?
    public let field: String
    public let value: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case op
        case type
        case field
        case value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.op = try container.decodeIfPresent(String.self, forKey: .op)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.field = try container.decode(String.self, forKey: .field)
        do {
            if let valueArray = try? container.decode([String].self, forKey: .value) {
                self.value = valueArray
            } else if let valueString = try? container.decode(String.self, forKey: .value) {
                self.value = [valueString]
            } else if let valueInt = try? container.decode(Int.self, forKey: .value) {
                self.value = [String(valueInt)]
            } else if try container.decodeNil(forKey: .value) {
                self.value = []
            } else {
                throw DecodingError.dataCorruptedError(forKey: .value, in: container, debugDescription: "Value must be a String, an array of Strings, an Int, or null")
            }
        } catch {
            throw DecodingError.dataCorruptedError(forKey: .value, in: container, debugDescription: "Value must be a String, an array of Strings, an Int, or null")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(op, forKey: .op)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encode(field, forKey: .field)
        try container.encode(value, forKey: .value)
    }
}

public struct Token: Codable, Sendable {
    public let accessToken: String
    public let refreshToken: String

    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

public struct TokenResponse: Codable, Sendable {
    public let accessToken: String
    public let refreshToken: String

    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

public struct Dashboard: Codable, Identifiable, Sendable {
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
    public let style: [String: JSONAny]?
}

public struct CommonFilterValue: Codable, Sendable {
    public let fields: [String]
    public let period: Period
    public let clauses: [Clause]
    public let periods: [Period]
    public let quickFilters: [String: JSONAny]
    public let customFieldsNames: [String: JSONAny]?

    enum CodingKeys: String, CodingKey {
        case fields
        case period
        case clauses
        case periods
        case quickFilters
        case customFieldsNames
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fields = try container.decode([String].self, forKey: .fields)
        self.period = try container.decode(Period.self, forKey: .period)
        self.clauses = try container.decode([Clause].self, forKey: .clauses)
        self.quickFilters = try container.decode([String: JSONAny].self, forKey: .quickFilters)
        self.customFieldsNames = try container.decodeIfPresent([String: JSONAny].self, forKey: .customFieldsNames)

        // Custom decoding for periods
        var periodsContainer = try container.nestedUnkeyedContainer(forKey: .periods)
        var decodedPeriods: [Period] = []
        while !periodsContainer.isAtEnd {
            do {
                if let periodString = try? periodsContainer.decode(String.self) {
                    decodedPeriods.append(Period(type: periodString, from: nil, to: nil))
                } else {
                    let period = try periodsContainer.decode(Period.self)
                    decodedPeriods.append(period)
                }
            } catch {
                _ = try? periodsContainer.decodeNil()
                continue
            }
        }
        self.periods = decodedPeriods
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fields, forKey: .fields)
        try container.encode(period, forKey: .period)
        try container.encode(clauses, forKey: .clauses)
        try container.encode(periods, forKey: .periods)
        try container.encode(quickFilters, forKey: .quickFilters)
        try container.encodeIfPresent(customFieldsNames, forKey: .customFieldsNames)
    }
}

public struct Period: Codable, Sendable {
    public let type: String
    public let from: String?
    public let to: String?

    public init(type: String, from: String? = nil, to: String? = nil) {
        self.type = type
        self.from = from
        self.to = to
    }
}

public struct Layout: Codable, Sendable {
    public let mobile: [LayoutItem]?
    public let desktop: [LayoutItem]?
    public let panels: [String]?

    enum CodingKeys: String, CodingKey {
        case mobile
        case desktop
        case panels
    }
}

public struct LayoutItem: Codable, Sendable {
    public let h: Int
    public let w: Int
    public let x: Int?
    public let y: Int?
    public let i: String
    public let minH: Int?
    public let minW: Int?
    public let moved: Bool?
    public let isStatic: Bool?

    enum CodingKeys: String, CodingKey {
        case h
        case w
        case x
        case y
        case i
        case minH
        case minW
        case moved
        case isStatic = "static"
    }
}

public struct Widget: Codable, Identifiable, Sendable {
    public let id: String
    public var title: String
    public let description: String?
    public let widget: String
    public let isQL: Bool
    public let query: WidgetQuery?
    public let style: [String: JSONAny]?
    public let visualization: Visualization?
    public let dependOn: [Dependency]?
    public let ignoreCommonFilter: Bool
}

public struct WidgetQuery: Codable, Sendable {
    public let view: String
    public let limit: Int?
    public let table: String?
    public let fields: [QueryField]
    public let filter: WidgetFilter?
    public let groupBy: [String]
    public let orderBy: [OrderBy]

    enum CodingKeys: String, CodingKey {
        case view
        case limit
        case table
        case fields
        case filter
        case groupBy
        case orderBy
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.view = try container.decode(String.self, forKey: .view)
        self.limit = try container.decodeIfPresent(Int.self, forKey: .limit)
        self.table = try container.decodeIfPresent(String.self, forKey: .table)
        self.fields = try container.decode([QueryField].self, forKey: .fields)
        self.filter = try container.decodeIfPresent(WidgetFilter.self, forKey: .filter)
        self.groupBy = try container.decodeIfPresent([String].self, forKey: .groupBy) ?? []
        self.orderBy = try container.decodeIfPresent([OrderBy].self, forKey: .orderBy) ?? []
    }
}

public struct QueryField: Codable, Sendable {
    public let field: String?
    public let alias: String?
    public let aggregationFunc: String?
}

public struct WidgetFilter: Codable, Sendable {
    public let period: Period?
    public let clauses: [Clause]?

    enum CodingKeys: String, CodingKey {
        case period
        case clauses
    }
}

public struct OrderBy: Codable, Sendable {
    public let field: String
    public let desc: Bool?
}

public struct Dialog: Codable, Sendable {
    public let layout: Layout?
    public let widgets: [Widget]?
}

public struct Visualization: Codable, Sendable {
    public let hidden: [String]?
    public let op: [String]?
    public let field: [String]?
    public let fields: [String]?
    public let noDataLink: String
    public let noDataValue: String
    public let noDataFormat: String
    public let rowsPerPage: String?
    public let virtualFields: [String?]? // Changed to support null elements
    public let autoplay: Bool?
    public let qlFilters: [JSONAny]?
    public let archiveEnabled: Bool?
    public let dialog: Dialog?

    enum CodingKeys: String, CodingKey {
        case hidden
        case op
        case field
        case fields
        case noDataLink
        case noDataValue
        case noDataFormat
        case rowsPerPage
        case virtualFields
        case autoplay
        case qlFilters
        case archiveEnabled
        case dialog
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hidden = try container.decodeIfPresent([String].self, forKey: .hidden)
        self.op = try container.decodeIfPresent([String].self, forKey: .op)

        if let fieldArray = try? container.decode([String].self, forKey: .field) {
            self.field = fieldArray
        } else if let fieldString = try? container.decode(String.self, forKey: .field) {
            self.field = [fieldString]
        } else {
            self.field = nil
        }

        if var fieldsContainer = try? container.nestedUnkeyedContainer(forKey: .fields) {
            var decodedFields: [String] = []
            while !fieldsContainer.isAtEnd {
                if let field = try? fieldsContainer.decode(String.self) {
                    decodedFields.append(field)
                } else if try fieldsContainer.decodeNil() {
                    continue
                } else {
                    throw DecodingError.dataCorruptedError(forKey: .fields, in: container, debugDescription: "Fields must be an array of Strings or null")
                }
            }
            self.fields = decodedFields
        } else {
            self.fields = nil
        }

        self.noDataLink = try container.decode(String.self, forKey: .noDataLink)
        self.noDataValue = try container.decode(String.self, forKey: .noDataValue)
        self.noDataFormat = try container.decode(String.self, forKey: .noDataFormat)

        if let rowsPerPageInt = try? container.decode(Int.self, forKey: .rowsPerPage) {
            self.rowsPerPage = String(rowsPerPageInt)
        } else if let rowsPerPageStr = try? container.decode(String.self, forKey: .rowsPerPage) {
            self.rowsPerPage = rowsPerPageStr
        } else {
            self.rowsPerPage = nil
        }

        if var virtualFieldsContainer = try? container.nestedUnkeyedContainer(forKey: .virtualFields) {
            var decodedVirtualFields: [String?] = []
            while !virtualFieldsContainer.isAtEnd {
                if let field = try? virtualFieldsContainer.decode(String.self) {
                    decodedVirtualFields.append(field)
                } else if try virtualFieldsContainer.decodeNil() {
                    decodedVirtualFields.append(nil)
                } else {
                    throw DecodingError.dataCorruptedError(forKey: .virtualFields, in: container, debugDescription: "VirtualFields must be an array of Strings or null")
                }
            }
            self.virtualFields = decodedVirtualFields
        } else {
            self.virtualFields = nil
        }

        self.autoplay = try container.decodeIfPresent(Bool.self, forKey: .autoplay)
        self.qlFilters = try container.decodeIfPresent([JSONAny].self, forKey: .qlFilters)
        self.archiveEnabled = try container.decodeIfPresent(Bool.self, forKey: .archiveEnabled)
        self.dialog = try container.decodeIfPresent(Dialog.self, forKey: .dialog)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(hidden, forKey: .hidden)
        try container.encodeIfPresent(op, forKey: .op)
        try container.encodeIfPresent(field, forKey: .field)
        try container.encodeIfPresent(fields, forKey: .fields)
        try container.encode(noDataLink, forKey: .noDataLink)
        try container.encode(noDataValue, forKey: .noDataValue)
        try container.encode(noDataFormat, forKey: .noDataFormat)
        try container.encodeIfPresent(rowsPerPage, forKey: .rowsPerPage)
        try container.encodeIfPresent(virtualFields, forKey: .virtualFields)
        try container.encodeIfPresent(autoplay, forKey: .autoplay)
        try container.encodeIfPresent(qlFilters, forKey: .qlFilters)
        try container.encodeIfPresent(archiveEnabled, forKey: .archiveEnabled)
        try container.encodeIfPresent(dialog, forKey: .dialog)
    }
}

public struct Dependency: Codable, Sendable {
    public let id: String
    public let field: String
    public let translation: String?

    enum CodingKeys: String, CodingKey {
        case id
        case field
        case translation
    }
}

// MARK: - JSON Helpers

public class JSONNull: Codable, Hashable {
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool { return true }
    public var hashValue: Int { return 0 }
    public init() {}
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

public class JSONCodingKey: CodingKey, @unchecked Sendable {
    public let key: String

    required public init?(intValue: Int) { return nil }
    required public init?(stringValue: String) { self.key = stringValue }
    public var intValue: Int? { return nil }
    public var stringValue: String { return key }
}

public class JSONAny: Codable, @unchecked Sendable {
    public let value: Any

    public static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    public static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    public static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) { return value }
        if let value = try? container.decode(Int64.self) { return value }
        if let value = try? container.decode(Double.self) { return value }
        if let value = try? container.decode(String.self) { return value }
        if container.decodeNil() { return JSONNull() }
        throw decodingError(forCodingPath: container.codingPath)
    }

    public static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) { return value }
        if let value = try? container.decode(Int64.self) { return value }
        if let value = try? container.decode(Double.self) { return value }
        if let value = try? container.decode(String.self) { return value }
        if let value = try? container.decodeNil() { if value { return JSONNull() } }
        if var container = try? container.nestedUnkeyedContainer() { return try decodeArray(from: &container) }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) { return try decodeDictionary(from: &container) }
        throw decodingError(forCodingPath: container.codingPath)
    }

    public static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) { return value }
        if let value = try? container.decode(Int64.self, forKey: key) { return value }
        if let value = try? container.decode(Double.self, forKey: key) { return value }
        if let value = try? container.decode(String.self, forKey: key) { return value }
        if let value = try? container.decodeNil(forKey: key) { if value { return JSONNull() } }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) { return try decodeArray(from: &container) }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) { return try decodeDictionary(from: &container) }
        throw decodingError(forCodingPath: container.codingPath)
    }

    public static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd { let value = try decode(from: &container); arr.append(value) }
        return arr
    }

    public static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys { let value = try decode(from: &container, forKey: key); dict[key.stringValue] = value }
        return dict
    }

    public static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool { try container.encode(value) }
            else if let value = value as? Int64 { try container.encode(value) }
            else if let value = value as? Double { try container.encode(value) }
            else if let value = value as? String { try container.encode(value) }
            else if value is JSONNull { try container.encodeNil() }
            else if let value = value as? [Any] { var container = container.nestedUnkeyedContainer(); try encode(to: &container, array: value) }
            else if let value = value as? [String: Any] { var container = container.nestedContainer(keyedBy: JSONCodingKey.self); try encode(to: &container, dictionary: value) }
            else { throw encodingError(forValue: value, codingPath: container.codingPath) }
        }
    }

    public static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool { try container.encode(value, forKey: key) }
            else if let value = value as? Int64 { try container.encode(value, forKey: key) }
            else if let value = value as? Double { try container.encode(value, forKey: key) }
            else if let value = value as? String { try container.encode(value, forKey: key) }
            else if value is JSONNull { try container.encodeNil(forKey: key) }
            else if let value = value as? [Any] { var container = container.nestedUnkeyedContainer(forKey: key); try encode(to: &container, array: value) }
            else if let value = value as? [String: Any] { var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key); try encode(to: &container, dictionary: value) }
            else { throw encodingError(forValue: value, codingPath: container.codingPath) }
        }
    }

    public static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool { try container.encode(value) }
        else if let value = value as? Int64 { try container.encode(value) }
        else if let value = value as? Double { try container.encode(value) }
        else if let value = value as? String { try container.encode(value) }
        else if value is JSONNull { try container.encodeNil() }
        else { throw encodingError(forValue: value, codingPath: container.codingPath) }
    }

    required public init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() { self.value = try JSONAny.decodeArray(from: &arrayContainer) }
        else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) { self.value = try JSONAny.decodeDictionary(from: &container) }
        else { let container = try decoder.singleValueContainer(); self.value = try JSONAny.decode(from: container) }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] { var container = encoder.unkeyedContainer(); try JSONAny.encode(to: &container, array: arr) }
        else if let dict = self.value as? [String: Any] { var container = encoder.container(keyedBy: JSONCodingKey.self); try JSONAny.encode(to: &container, dictionary: dict) }
        else { var container = encoder.singleValueContainer(); try JSONAny.encode(to: &container, value: self.value) }
    }
}


