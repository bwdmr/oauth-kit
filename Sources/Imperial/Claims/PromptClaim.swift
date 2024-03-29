///
public struct PromptClaim: ImperialClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: ImperialCodingKey = "promt"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
