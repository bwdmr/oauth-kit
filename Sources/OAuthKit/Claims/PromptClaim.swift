///
public struct PromptClaim: OAuthClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: OAuthCodingKey = "promt"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
