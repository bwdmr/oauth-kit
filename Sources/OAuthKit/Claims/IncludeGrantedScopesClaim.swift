///
public struct IncludeGrantedScopesClaim: OAuthBooleanClaim, Equatable  {
  
  public static let key: OAuthCodingKey = "inlcude_granted_scopes"
  
  public var value: Bool
  
  public init(value: Bool) {
    self.value = value
  }
}
