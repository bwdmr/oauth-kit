///
public struct ClientSecretClaim: OAuthClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: OAuthCodingKey = "client_secret"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
