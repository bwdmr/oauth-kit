///
public struct TokenClaim: OAuthClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: OAuthCodingKey = "token"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
