///
public struct RedirectURIClaim: ImperialClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: ImperialCodingKey = "redirect_uri"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
