//
//  ResultTypeEnum.swift
//  Dashboards
//
//  Created by Логунов Даниил on 9/26/25.
//


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
