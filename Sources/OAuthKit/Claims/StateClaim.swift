///
public struct StateClaim: OAuthClaim, Equatable, ExpressibleByStringLiteral {
  
  static public let key: OAuthCodingKey = "state"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
