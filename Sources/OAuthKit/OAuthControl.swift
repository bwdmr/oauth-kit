import Foundation

public actor OAuthControl: Sendable {
  
  private var storage: [OAuthIdentifier: OAuthService]
  private var `default`: OAuthService?
  
  public init() {
    self.storage = [:]
  }
  
  /// add a service
  @discardableResult
  func add(_ oauthservice: OAuthService, for id: OAuthIdentifier) -> Self {
    
    if self.storage[id] != nil {
      print("Warning: Overwriting existing OAuth configuration for key identifier; '\(id)'.")
    }
    self.storage[id] = oauthservice
    
    if self.default != nil {
      print("Warning: Overwriting existing default OAuth configuration.")
    }
    self.default = oauthservice
    
    return self
  }
  
  
  /// remove a service
  func remove(_ id: OAuthIdentifier) -> Self {
    if let _ = self.storage[id] {
      self.storage[id] = nil
    }
    
    return self
  }
  
 
  /// set default service
  @discardableResult
  public func use(_ id: OAuthIdentifier) throws -> Self {
    if let service = self.storage[id] {
      self.default = service
    }
    throw OAuthError.invalidService("\(id)")
  }
  
  
  
}
