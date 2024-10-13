///
public struct LoginHintClaim: OAuthClaim, Equatable, ExpressibleByStringLiteral {
  
  public static let key: OAuthCodingKey = "login_hint"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
