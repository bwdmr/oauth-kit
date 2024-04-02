import Foundation




public protocol OAuthToken: Codable, Sendable {
  func verify() async throws
}


public protocol OAuthServicable {
  func authorizationURL() throws -> URL
  func accessURL(code: String) throws -> URL
}

public struct OAuthIdentifier: Hashable, Equatable, Sendable {
  public let string: String
  
  public init(string: String) {
    self.string = string
  }
}

extension OAuthIdentifier: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    try self.init(string: container.decode(String.self))
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.string)
  }
}

extension OAuthIdentifier: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.init(string: value)
  }
}



public actor OAuthService: Sendable {
  
  private var storage: [OAuthIdentifier: OAuthServicable]
  private var `default`: OAuthServicable?
  
  public init() {
    self.storage = [:]
  }
  
  
  /// add a service
  @discardableResult
  func add(_ oauthservice: OAuthServicable, for id: OAuthIdentifier) -> Self {
    
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
  func authorizationURL(_ id: OAuthIdentifier? = nil) throws -> URL {
    if let id = id {
      
      if let service = self.storage[id] {
        return try service.authorizationURL() }
    }
    
    else {
      if let `default` = `default` {
        return try `default`.authorizationURL()
    }}
    
    throw OAuthError.invalidService("default nor 'n/A' is available")
  }
  
  
  ///
  func accessURL(_ id: OAuthIdentifier? = nil, code: String) throws -> URL {
    if let id = id {
      
      if let service = self.storage[id] {
        return try service.accessURL(code: code) }
    }
    
    else {
      if let `default` = `default` {
        return try `default`.accessURL(code: code)
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
