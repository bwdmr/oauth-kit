///
public struct GrantTypeClaim: ImperialClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: ImperialCodingKey = "grant_type"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
