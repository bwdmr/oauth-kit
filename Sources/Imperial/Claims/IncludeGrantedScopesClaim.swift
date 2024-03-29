///
public struct IncludeGrantedScopesClaim: ImperialBooleanClaim, Equatable  {
  
  public static var key: ImperialCodingKey = "inlcude_granted_scopes"
  
  public var value: Bool
  
  public init(value: Bool) {
    self.value = value
  }
}
