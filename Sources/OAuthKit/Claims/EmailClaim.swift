///
public struct EmailClaim: OAuthClaim, Equatable, ExpressibleByStringLiteral {
  
  public static let key: OAuthCodingKey = "email"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
