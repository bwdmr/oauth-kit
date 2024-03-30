import Foundation


/// OAuth error type
public struct OAuthError: Error, @unchecked Sendable {
  public struct ErrorType: Sendable, Hashable, CustomStringConvertible {
    
    enum Base: Sendable, Hashable {
      case invalidBool
      case invalidInt
      case invalidURL
      case redirecturiMismatch
      case claimMissingRequiredMember
      case claimVerificationFailure
      case generic
    }
    
    let base: Base
    
    private init(_ base: Base) {
      self.base = base
    }
  
    public static let invalidBool = Self(.invalidBool)
    public static let invalidInt = Self(.invalidInt)
    public static let invalidURL = Self(.invalidURL)
    public static let redirecturiMismatch = Self(.redirecturiMismatch)
    public static let claimMissingRequiredMember = Self(.claimMissingRequiredMember)
    public static let claimVerificationFailure = Self(.claimVerificationFailure)
    public static let generic = Self(.generic)
    
    public var description: String {
      switch self.base {
      case .invalidBool:
        "invalid_bool"
      case .invalidInt:
        "invalid_int"
      case .invalidURL:
        "invalid_url"
      case .claimMissingRequiredMember:
        "claim_missing_required_member"
      case .claimVerificationFailure:
        "claim_verification_failure"
      case .redirecturiMismatch:
        "redirect_uri_mismatch"
      case .generic:
        "generic"
      }
    }
  }
  
  
  private final class Backing {
    fileprivate var errorType: ErrorType
    fileprivate var name: String?
    fileprivate var reason: String?
    fileprivate var underlying: Error?
    fileprivate var identifier: String?
    fileprivate var failedGrant: (any OAuthClaim)?
    
    init(errorType: ErrorType) {
      self.errorType = errorType
    }
  }
  
  private var backing: Backing
  
  public internal(set) var errorType: ErrorType {
    get { self.backing.errorType }
    set { self.backing.errorType = newValue }
  }
  
  public internal(set) var name: String? {
    get { self.backing.name }
    set { self.backing.name = newValue }
  }
  
  public internal(set) var reason: String? {
    get { self.backing.reason }
    set { self.backing.reason = newValue }
  }
  
  public internal(set) var underlying: Error? {
    get { self.backing.underlying }
    set { self.backing.underlying = newValue }
  }
  
  public internal(set) var identifier: String? {
    get { self.backing.identifier }
    set { self.backing.identifier = newValue }
  }
  
  public internal(set) var failedClaim: (any OAuthClaim)? {
    get { self.backing.failedGrant }
    set { self.backing.failedGrant = newValue }
  }
  
  init(errorType: ErrorType) {
    self.backing = .init(errorType: errorType)
  }
 
  
  ///
  public static func invalidBool(_ name: String) -> Self {
    var new = Self(errorType: .invalidBool)
    new.name = name
    return new
  }
  
  
  ///
  public static func invalidInt(_ name: String) -> Self {
    var new = Self(errorType: .invalidInt)
    new.name = name
    return new
  }
  
 
  ///
  public static func invalidURL(_ name: String) -> Self {
    var new = Self(errorType: .invalidURL)
    new.name = name
    return new
  }
  
 
  ///
  public static func claimMissingRequiredMember(failedClaim: (any OAuthClaim)?, reason: String) -> Self {
    var new = Self(errorType: .claimMissingRequiredMember)
    new.failedClaim = failedClaim
    new.reason = reason
    return new
  }
  
  
  ///
  public static func claimVerificationFailure(failedClaim: (any OAuthClaim)?, reason: String) -> Self {
    var new = Self(errorType: .claimVerificationFailure)
    new.failedClaim = failedClaim
    new.reason = reason
    return new
  }
  
  
  ///
  public static func redirecturiMismatch(failedClaim: (any OAuthClaim)?, reason: String) -> Self {
    var new = Self(errorType: .redirecturiMismatch)
    new.failedClaim = failedClaim
    new.reason = reason
    return new
  }
  
  
  ///
  public static func generic(identifier: String, reason: String) -> Self {
    var new = Self(errorType: .generic)
    new.identifier = identifier
    new.reason = reason
    return new
  }
}

extension OAuthError: CustomStringConvertible {
  public var description: String {
    var result = #"OAuthError(errorType: \#(self.errorType)"#
    
    if let name {
      result.append(", name: \(String(reflecting: name))") }
    
    if let failedClaim {
      result.append(", failedClaim: \(String(reflecting: failedClaim))") }
    
    if let reason {
      result.append(", reason: \(String(reflecting: reason))") }
    
    if let underlying {
      result.append(", underlying: \(String(reflecting: underlying))") }
    
    if let identifier {
      result.append(", identifier: \(String(reflecting: identifier))") }
    
    result.append(")")
    return result
  }
}
