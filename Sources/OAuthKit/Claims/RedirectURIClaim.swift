///
public struct RedirectURIClaim: OAuthClaim, Equatable, ExpressibleByStringLiteral {
  
  public static let key: OAuthCodingKey = "redirect_uri"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
