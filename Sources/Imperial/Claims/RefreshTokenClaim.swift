///
public struct RefreshTokenClaim: ImperialClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: ImperialCodingKey = "refresh_token"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
