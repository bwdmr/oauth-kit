///
public struct TokenTypeClaim: OAuthClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: OAuthCodingKey = "token_type"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
