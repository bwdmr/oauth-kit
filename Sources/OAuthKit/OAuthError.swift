import Foundation


/// OAuth error type
public struct OAuthError: Error, @unchecked Sendable {
  public struct ErrorType: Sendable, Hashable, CustomStringConvertible {
    
    enum Base: Sendable, Hashable {
      case claimMissingRequiredMember
      case claimVerificationFailure
      case generic
      case invalidBool
      case invalidData
      case invalidInt
      case invalidURL
      case invalidService
      case invalidToken
      case missingService
      case missingRequirement
      case redirecturiMismatch
      case tokenScopeDefinitionFailure
    }
    
    let base: Base
    
    private init(_ base: Base) {
      self.base = base
    }
  
    public static let claimMissingRequiredMember = Self(.claimMissingRequiredMember)
    public static let claimVerificationFailure = Self(.claimVerificationFailure)
    public static let tokenScopeDefinitionFailure = Self(.tokenScopeDefinitionFailure)
    public static let generic = Self(.generic)
    public static let invalidBool = Self(.invalidBool)
    public static let invalidData = Self(.invalidData)
    public static let invalidInt = Self(.invalidInt)
    public static let invalidURL = Self(.invalidURL)
    public static let invalidService = Self(.invalidService)
    public static let invalidToken = Self(.invalidToken)
    public static let missingService = Self(.missingService)
    public static let missingRequirement = Self(.missingRequirement)
    public static let redirecturiMismatch = Self(.redirecturiMismatch)
    
    public var description: String {
      switch self.base {
      case .claimMissingRequiredMember:
        "claim_missing_required_member"
      case .claimVerificationFailure:
        "claim_verification_failure"
      case .generic:
        "generic"
      case .invalidBool:
        "invalid_bool"
      case .invalidInt:
        "invalid_int"
      case .invalidData:
        "invalid_data"
      case .invalidURL:
        "invalid_url"
      case .invalidService:
        "invalid_service"
      case .invalidToken:
        "invalid_token"
      case .missingService:
        "missing_service"
      case .missingRequirement:
        "missing_requirement"
      case .redirecturiMismatch:
        "redirect_uri_mismatch"
      case .tokenScopeDefinitionFailure:
        "token_scope_definition_failure"
      }
    }
  }
  
  
  private final class Backing {
    fileprivate var errorType: ErrorType
    fileprivate var name: String?
    fileprivate var reason: String?
    fileprivate var underlying: Error?
    fileprivate var identifier: String?
    fileprivate var failedClaim: (any OAuthClaim)?
    fileprivate var failedToken: (any OAuthToken)?
    
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
    get { self.backing.failedClaim }
    set { self.backing.failedClaim = newValue }
  }
  
  public internal(set) var failedToken: (any OAuthToken)? {
    get { self.backing.failedToken }
    set { self.backing.failedToken = newValue }
  }
  
  init(errorType: ErrorType) {
    self.backing = .init(errorType: errorType)
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
  public static func tokenScopeDefinitionFailure(failedToken: (any OAuthToken)?, reason: String) -> Self {
    var new = Self(errorType: .tokenScopeDefinitionFailure)
    new.failedToken = failedToken
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
  
  
  ///
  public static func invalidBool(_ name: String) -> Self {
    var new = Self(errorType: .invalidBool)
    new.name = name
    return new
  }
  
  
  ///
  public static func invalidData(_ name: String) -> Self {
    var new = Self(errorType: .invalidData)
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
  public static func invalidService(_ name: String) -> Self {
    var new = Self(errorType: .invalidService)
    new.name = name
    return new
  }
  
 
  ///
  public static func invalidToken(_ name: String) -> Self {
    var new = Self(errorType: .invalidToken)
    new.name = name
    return new
  }
  
  
  ///
  public static func missingService(_ name: String) -> Self {
    var new = Self(errorType: .missingService)
    new.name = name
    return new
  }
  
  
  ///
  public static func missingRequirement(failedToken: (any OAuthToken)?, reason: String) -> Self {
    var new = Self(errorType: .missingRequirement)
    new.identifier = reason
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
}

extension OAuthError: CustomStringConvertible {
  public var description: String {
    var result = #"OAuthError(errorType: \#(self.errorType)"#
    
    if let name {
      result.append(", name: \(String(reflecting: name))") }
    
    if let failedToken {
      result.append(", failedToken: \(String(reflecting: failedToken))") }
    
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
