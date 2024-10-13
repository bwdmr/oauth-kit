///
public struct TokenTypeClaim: OAuthClaim, Equatable, ExpressibleByStringLiteral {
  public static let key: OAuthCodingKey = "token_type"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
