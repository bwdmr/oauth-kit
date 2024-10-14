import Foundation


public actor OAuthService: Sendable {
  
  private var storage: [OAuthIdentifier: OAuthServiceable]
  
  public init() {
    self.storage = [:]
  }
 
  
  /// add a service
  @discardableResult
  public func register(_ service: OAuthServiceable)
  async throws -> Self {
    
    let id = await service.id
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
      let encodedToken = Array(token)
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
