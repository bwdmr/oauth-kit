///
public struct AccessTokenClaim: OAuthClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: OAuthCodingKey = "access_token"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
