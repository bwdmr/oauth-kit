import Foundation
import Combine



public actor OAuthService: Sendable {
  
  private var storage: [OAuthIdentifier: OAuthServiceable]
  private var `default`: OAuthServiceable?
  
  public init() {
    self.storage = [:]
  }
  
  
  /// add a service
  @discardableResult
  public func add(_ oauthservice: OAuthServiceable, for id: OAuthIdentifier) throws -> Self {
    if self.storage[id] != nil {
      print("Warning: Overwriting existing OAuth configuration for service identifier; '\(id)'.") }
    self.storage[id] = oauthservice
    self.default = oauthservice
    
    return self
  }
  
  
  /// remove a service
  public func remove(_ id: OAuthIdentifier) -> Self {
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
  
  
  ///
  func authenticationURL(_ id: OAuthIdentifier? = nil) throws -> URL {
    if let id = id {
      
      if let service = self.storage[id] {
        return try service.authenticationURL()
      }}
    
    else {
      if let `default` = `default` {
        return try `default`.authenticationURL()
      }}
    
    throw OAuthError.invalidService("default nor 'n/A' is available")
  }
  
  
  ///
  func tokenURL(_ id: OAuthIdentifier? = nil, code: String) throws -> URL {
    if let id = id {
      
      if let service = self.storage[id] {
        return try service.tokenURL(code: code)
      }}
    
    else {
      if let `default` = `default` {
        return try `default`.tokenURL(code: code)
      }}
    
    throw OAuthError.invalidService("default nor 'n/A' is available")
  }
  
  
  ///
  public func verify<Token>(_ token: String, as _: Token.Type = Token.self)
  async throws -> Token where Token: OAuthToken
  {
    try await self.verify([UInt8](token.utf8), as: Token.self)
  }
  
  
  ///
  public func verify<Token>(_ token: some DataProtocol, as _: Token.Type = Token.self)
  async throws -> Token where Token: OAuthToken {
    let jsonDecoder: OAuthJSONDecoder = .defaultForOAuth
    
    var _token: Token
    do {
      let encodedToken = token.copyBytes()
      _token = try jsonDecoder.decode(
        Token.self, from: .init(encodedToken.base64URLDecodedBytes()) )
    } catch {
      throw OAuthError.invalidToken(
        "Couldn't decode OAuth with error: \(String(describing: error))")
    }
    
    try await _token.verify()
    return _token
  }
}
