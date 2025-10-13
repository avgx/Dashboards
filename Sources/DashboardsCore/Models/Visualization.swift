import Foundation

public struct Visualization: Codable, Sendable {
    public let hidden: [String]?
    public let op: [String]?
    public let field: [String]?
    public let fields: [String]?
    public let noDataLink: String?
    public let noDataValue: String?
    public let noDataFormat: String? 
    public let rowsPerPage: String?
    public let virtualFields: [String?]?
    public let autoplay: Bool?
    public let chartType: String?
    public let qlFilters: [Any]?
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
        case chartType
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
        
        self.noDataLink = try container.decodeIfPresent(String.self, forKey: .noDataLink)
        self.noDataValue = try container.decodeIfPresent(String.self, forKey: .noDataValue)
        self.noDataFormat = try container.decodeIfPresent(String.self, forKey: .noDataFormat)
        
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
        do {
            let qlFiltersData = try container.decodeIfPresent(Data.self, forKey: .qlFilters)
            if let data = qlFiltersData, !data.isEmpty {
                self.qlFilters = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
            } else {
                self.qlFilters = nil
            }
        } catch {
            self.qlFilters = nil
        }
        self.archiveEnabled = try container.decodeIfPresent(Bool.self, forKey: .archiveEnabled)
        self.dialog = try container.decodeIfPresent(Dialog.self, forKey: .dialog)
        self.chartType = try container.decodeIfPresent(String.self, forKey: .chartType)
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
        if let qlFilters = qlFilters {
            let qlFiltersData = try JSONSerialization.data(withJSONObject: qlFilters, options: [])
            try container.encode(qlFiltersData, forKey: .qlFilters)
        }
        try container.encodeIfPresent(archiveEnabled, forKey: .archiveEnabled)
        try container.encodeIfPresent(dialog, forKey: .dialog)
    }
}
