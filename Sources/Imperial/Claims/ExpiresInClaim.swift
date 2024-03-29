import Foundation

///
public struct ExpiresInClaim: ImperialIntegerClaim, Equatable {
  
  public static var key: ImperialCodingKey = "expires_in"
  
  public var value: Int
  
  public init(value: Int) {
    let currentTimestamp = Int(Date().timeIntervalSince1970)
    self.value = currentTimestamp + value
  }
 
  public func verifyNotExpired(currentDate: Int = Int(Date.init().timeIntervalSince1970)) throws {
    if self.value < currentDate {
      throw ImperialError.claimVerificationFailure(failedClaim: self, reason: "expired")
    }
  }
}
