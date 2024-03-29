///
public struct AccessTypeClaim: ImperialClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: ImperialCodingKey = "access_type"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
