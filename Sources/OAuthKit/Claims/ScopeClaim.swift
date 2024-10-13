

public struct ScopeClaim: OAuthMultiValueClaim, Codable, Sendable {
  static public let key: OAuthCodingKey = "scope"
  
  public var value: [String]
  
  public init(value: [String]) {
    precondition(!value.isEmpty, "A scope claim must have at least one value.")
    self.value = value
  }
  
  public init(stringLiteral value: String) {
    self.init(value: value)
  }
}




