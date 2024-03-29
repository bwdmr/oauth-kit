///
public struct ClientIDClaim: OAuthClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: OAuthCodingKey = "client_id"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
