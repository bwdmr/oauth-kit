///
public struct TokenTypeClaim: ImperialClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: ImperialCodingKey = "token_type"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
