import Foundation

public actor OAuthServices: Sendable {
  
  private var storage: [OAuthIdentifier: OAuthService]
  private var `default`: OAuthService?
  
  public init() {
    self.storage = [:]
  }
  
  /// add a service
  @discardableResult
  func add(_ oauthservice: OAuthService, for id: OAuthIdentifier) -> Self {
    
    if self.storage[id] != nil {
      print("Warning: Overwriting existing OAuth configuration for key identifier; '\(id)'.") }
    self.storage[id] = oauthservice
    
    if self.default != nil {
      print("Warning: Overwriting existing default OAuth configuration.") }
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
