import Foundation

public struct QueryExpression: Codable, Sendable {
    public let left: ExpressionSide?
    public let right: ExpressionSide?
    public let alias: String?
    public let operatorType: String?
    
    enum CodingKeys: String, CodingKey {
        case left
        case right
        case alias
        case operatorType = "operator"
    }
    
    public init(left: ExpressionSide? = nil,
                right: ExpressionSide? = nil,
                alias: String? = nil,
                operatorType: String? = nil) {
        let validOperators = ["add", "subtract", "specified"]
        if let op = operatorType, validOperators.contains(op) {
            self.operatorType = op
        } else if operatorType != nil {
            self.operatorType = "specified"
        } else {
            self.operatorType = nil
        }
        
        self.left = left
        self.right = right
        self.alias = alias
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.left = try container.decodeIfPresent(ExpressionSide.self, forKey: .left)
        self.right = try container.decodeIfPresent(ExpressionSide.self, forKey: .right)
        self.alias = try container.decodeIfPresent(String.self, forKey: .alias)
        
        let rawOperator = try container.decodeIfPresent(String.self, forKey: .operatorType)
        let validOperators = ["add", "subtract", "specified"]
        if let op = rawOperator, validOperators.contains(op) {
            self.operatorType = op
        } else if rawOperator != nil {
            self.operatorType = "specified"
        } else {
            self.operatorType = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(left, forKey: .left)
        try container.encodeIfPresent(right, forKey: .right)
        try container.encodeIfPresent(alias, forKey: .alias)
        try container.encodeIfPresent(operatorType, forKey: .operatorType)
    }
}
