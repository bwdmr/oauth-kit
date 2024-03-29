///
public struct ClientIDClaim: ImperialClaim, Equatable, ExpressibleByStringLiteral {
  
  public static var key: ImperialCodingKey = "client_id"
  
  public var value: String
  
  public init(value: String) {
    self.value = value
  }
}
