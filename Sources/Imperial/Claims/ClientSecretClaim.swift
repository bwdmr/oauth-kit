///
public struct ClientSecretClaim: ImperialClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: ImperialCodingKey = "client_secret"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
