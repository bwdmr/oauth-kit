import Foundation


/// OAuth error type
public struct OAuthError: Error, Sendable {
  public struct ErrorType: Sendable, Hashable, CustomStringConvertible {
    
    enum Base: String, Sendable {
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
      base.rawValue
    }
  }
  
  
  private final class Backing: Sendable {
    fileprivate let errorType: ErrorType
    fileprivate let name: String?
    fileprivate let reason: String?
    fileprivate let underlying: Error?
    fileprivate let identifier: String?
    fileprivate let failedClaim: (any OAuthClaim)?
    fileprivate let failedToken: (any OAuthToken)?
    
    init(
      errorType: ErrorType,
      name: String? = nil,
      reason: String? = nil,
      underlying: Error? = nil,
      identifier: String? = nil,
      failedClaim: (any OAuthClaim)? = nil,
      failedToken: (any OAuthToken)? = nil
      
    ) {
      self.errorType = errorType
      self.name = name
      self.reason = reason
      self.underlying = underlying
      self.identifier = identifier
      self.failedClaim = failedClaim
      self.failedToken = failedToken
    }
  }
  
  private var backing: Backing
  
  public var errorType: ErrorType { backing.errorType }
  public var name: String? { backing.name }
  public var reason: String? { backing.reason }
  public var underlying: (any Error)? { backing.underlying }
  public var identifier: String? { backing.identifier }
  public var failedClaim: (any OAuthClaim)? { backing.failedClaim }
  public var failedToken: (any OAuthToken)? { backing.failedToken }
  
  private init(backing: Backing) {
    self.backing = backing }
  
  private init(errorType: ErrorType) {
    self.backing = .init(errorType: errorType) }
  
  ///
  public static func claimMissingRequiredMember(failedClaim: (any OAuthClaim)?, reason: String) -> Self {
    .init(backing: .init(errorType: .claimMissingRequiredMember, reason: reason, failedClaim: failedClaim))
  }
  
  
  ///
  public static func claimVerificationFailure(failedClaim: (any OAuthClaim)?, reason: String) -> Self {
    .init(backing: .init(errorType: .claimVerificationFailure, reason: reason, failedClaim: failedClaim))
  }
  
  
  ///
  public static func tokenScopeDefinitionFailure(failedToken: (any OAuthToken)?, reason: String) -> Self {
    .init(backing: .init(errorType: .tokenScopeDefinitionFailure, reason: reason, failedToken: failedToken))
  }
  
    
  ///
  public static func generic(identifier: String, reason: String) -> Self {
    .init(backing: .init(errorType: .generic, reason: reason, identifier: identifier))
  }
  
  
  ///
  public static func invalidBool(_ name: String) -> Self {
    .init(backing: .init(errorType: .invalidBool, name: name))
  }
  
  
  ///
  public static func invalidData(_ name: String) -> Self {
    .init(backing: .init(errorType: .invalidData, name: name))
  }
  
  
  ///
  public static func invalidInt(_ name: String) -> Self {
    .init(backing: .init(errorType: .invalidInt, name: name))
  }
 
  
  ///
  public static func invalidURL(_ name: String) -> Self {
    .init(backing: .init(errorType: .invalidURL, name: name))
  }
  
  
  ///
  public static func invalidService(_ name: String) -> Self {
    .init(backing: .init(errorType: .invalidService, name: name))
  }
  
 
  ///
  public static func invalidToken(_ name: String) -> Self {
    .init(backing: .init(errorType: .invalidToken, name: name))
  }
  
  
  ///
  public static func missingService(_ name: String) -> Self {
    .init(backing: .init(errorType: .missingService, name: name))
  }
  
  
  ///
  public static func missingRequirement(failedToken: (any OAuthToken)?, reason: String) -> Self {
    .init(backing: .init(errorType: .missingRequirement, reason: reason, failedToken: failedToken))
  }
  
  
  ///
  public static func redirecturiMismatch(failedClaim: (any OAuthClaim)?, reason: String) -> Self {
    .init(backing: .init(errorType: .redirecturiMismatch, reason: reason, failedClaim: failedClaim))
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
