///
public struct ScopeClaim: ImperialClaim, Equatable, ExpressibleByStringLiteral {
  
  static public var key: ImperialCodingKey = "scope"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
