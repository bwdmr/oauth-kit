///
public struct CodeClaim: OAuthClaim, Equatable, ExpressibleByStringLiteral {
  
  public static let key: OAuthCodingKey = "code"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
