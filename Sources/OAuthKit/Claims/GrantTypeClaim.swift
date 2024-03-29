///
public struct GrantTypeClaim: OAuthClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: OAuthCodingKey = "grant_type"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
