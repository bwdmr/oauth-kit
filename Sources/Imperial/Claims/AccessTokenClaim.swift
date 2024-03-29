///
public struct AccessTokenClaim: ImperialClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: ImperialCodingKey = "access_token"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
