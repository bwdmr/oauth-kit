///
public struct StateClaim: ImperialClaim, Equatable, ExpressibleByStringLiteral {
  
  static public var key: ImperialCodingKey = "state"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
