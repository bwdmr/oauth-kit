///
public struct ResponseTypeClaim: OAuthClaim, Equatable, ExpressibleByStringLiteral {
  public static let key: OAuthCodingKey = "response_type"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
