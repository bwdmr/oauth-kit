///
public struct TokenClaim: ImperialClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: ImperialCodingKey = "token"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
