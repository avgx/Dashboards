import Foundation

public enum ResultTypeEnum: String, Codable {
    case composite = "composite"
    case datetime = "datetime"
    case dictionary = "dictionary"
    case image = "image"
    case json = "json"
    case number = "number"
    case string = "string"
    case typeSet = "set"
}
