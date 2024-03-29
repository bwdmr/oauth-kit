import Foundation

///
public struct ExpiresInClaim: ImperialUnixEpochClaim, Equatable {
  
  public static var key: ImperialCodingKey = "expires_in"
  
  public var value: Date
  
  public init(value: Date) {
    self.value = value
  }
  
  public func verifyNotExpired(currentDate: Date = .init()) throws {
    switch self.value.compare(currentDate) {
    case .orderedAscending, .orderedSame:
      throw ImperialError.claimVerificationFailure(failedClaim: self, reason: "expired")
    case .orderedDescending:
      break
    }
  }
}
