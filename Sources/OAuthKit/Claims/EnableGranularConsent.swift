///
public struct EnableGranularConsentClaim: OAuthBooleanClaim, Equatable  {
  
  public static var key: OAuthCodingKey = "enable_granular_consent"
  
  public var value: Bool
  
  public init(value: Bool) {
    self.value = value
  }
}
