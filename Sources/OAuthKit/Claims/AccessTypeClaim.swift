///
public struct AccessTypeClaim: OAuthClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: OAuthCodingKey = "access_type"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
