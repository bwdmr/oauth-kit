///
public struct RefreshTokenClaim: OAuthClaim, Equatable, ExpressibleByStringLiteral {
  
  public static let key: OAuthCodingKey = "refresh_token"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
