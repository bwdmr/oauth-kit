

public struct ScopeClaim: OAuthMultiValueClaim, Codable, Sendable {
  static public var key: OAuthCodingKey = "scope"
  
  public var value: [String]
  
  public var access: OAuthAccess?
  
  public init(value: [String]) {
    precondition(!value.isEmpty, "A scope claim must have at least one value.")
    self.value = value
  }
  
  public init(stringLiteral value: String) {
    self.init(value: value)
  }
}




