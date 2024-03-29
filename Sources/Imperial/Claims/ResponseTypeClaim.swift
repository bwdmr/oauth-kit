///
public struct ResponseTypeClaim: ImperialClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: ImperialCodingKey = "response_type"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
