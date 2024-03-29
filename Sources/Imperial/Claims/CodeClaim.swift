///
public struct CodeClaim: ImperialClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: ImperialCodingKey = "code"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
