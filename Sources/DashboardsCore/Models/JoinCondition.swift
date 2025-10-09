import Foundation

public struct JoinCondition: Codable {
    public let left: String
    public let right: String
    public let operatorType: String
    public let condition: String?

    enum CodingKeys: String, CodingKey {
        case left
        case right
        case operatorType = "operator"
        case condition
    }

    public init(left: String, right: String, operatorType: String, condition: String) {
        self.left = left
        self.right = right
        self.operatorType = operatorType
        self.condition = condition
    }
}
