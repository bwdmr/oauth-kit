import Foundation


public actor OAuthService: Sendable {
  
  private var storage: [OAuthIdentifier: OAuthServiceable]
  
  public init() {
    self.storage = [:]
  }
 
  
  /// add a service
  @discardableResult
  public func register<HeadToken>(_ service: OAuthServiceable, _ use: [OAuthToken], head: HeadToken)
  async throws -> Self where HeadToken: OAuthToken {
    
    guard use.count > 0 else {
      throw OAuthError.missingRequirement(failedToken: nil, reason: "a service requires atleast one OAuthToken.")
    }
   
    let id = await service.id
    
    let service = service
    
    for token in use {
      guard let scopeList = token.scope, scopeList.value.count == 1
      else {
        throw OAuthError.tokenScopeDefinitionFailure(
          failedToken: token, reason: "multiple scopes cannot be configured") }
    }
    
    try await service.add(use, head: head)
    
    if self.storage[id] != nil {
      print("Warning: Overwriting existing OAuth configuration for service identifier; '\(id)'.") }
    self.storage[id] = service
    
    return self
  }
  
  
  ///
  func authenticationURL(_ id: OAuthIdentifier) async throws -> URL {
    if let service = self.storage[id] {
      return try await service.authenticationURL() }
    
    throw OAuthError.invalidService("default nor 'n/A' is available")
  }
  
 
  
  ///
  func tokenURL(_ id: OAuthIdentifier, code: String) async throws -> (URL, [UInt8]) {
    if let service = self.storage[id] {
      return try await service.tokenURL(code: code) }
    
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
