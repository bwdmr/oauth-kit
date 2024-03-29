///
public struct EnableGranularConsentClaim: ImperialBooleanClaim, Equatable  {
  
  public static var key: ImperialCodingKey = "enable_granular_consent"
  
  public var value: Bool
  
  public init(value: Bool) {
    self.value = value
  }
}
