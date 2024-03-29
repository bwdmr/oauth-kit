///
public struct LoginHintClaim: ImperialClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: ImperialCodingKey = "login_hint"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
