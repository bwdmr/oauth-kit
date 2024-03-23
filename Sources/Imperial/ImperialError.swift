import Foundation
import Vapor


/// Imperial error type
public struct ImperialError: Error, @unchecked Sendable {
  public struct ErrorType: Sendable, Hashable, CustomStringConvertible {
    
    enum Base: Sendable, Hashable {
      case redirecturiMismatch
      case generic
    }
    
    let base: Base
    
    private init(_ base: Base) {
      self.base = base
    }
    
    public static let redirecturiMismatch = Self(.redirecturiMismatch)
    public static let generic = Self(.generic)
    public var description: String {
      switch self.base {
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
    fileprivate var failedGrant: (any ImperialGrant)?
    
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
  
  public internal(set) var failedClaim: (any ImperialGrant)? {
    get { self.backing.failedGrant }
    set { self.backing.failedGrant = newValue }
  }
  
  init(errorType: ErrorType) {
    self.backing = .init(errorType: errorType)
  }
  
  public static func redirecturiMismatch(failedClaim: (any ImperialGrant)?, reason: String) -> Self {
    var new = Self(errorType: .redirecturiMismatch)
    new.failedClaim = failedClaim
    new.reason = reason
    return new
  }
  
  public static func generic(identifier: String, reason: String) -> Self {
    var new = Self(errorType: .generic)
    new.identifier = identifier
    new.reason = reason
    return new
  }
}

extension ImperialError: CustomStringConvertible {
  public var description: String {
    var result = #"ImperialError(errorType: \#(self.errorType)"#
    
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
