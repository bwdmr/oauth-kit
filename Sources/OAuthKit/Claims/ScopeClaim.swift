///
public struct ScopeClaim: OAuthClaim, Equatable, ExpressibleByStringLiteral {
  
  static public var key: OAuthCodingKey = "scope"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
