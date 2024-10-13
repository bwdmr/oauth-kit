///
public struct PromptClaim: OAuthClaim, Equatable, ExpressibleByStringLiteral {
  
  public static let key: OAuthCodingKey = "prompt"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
