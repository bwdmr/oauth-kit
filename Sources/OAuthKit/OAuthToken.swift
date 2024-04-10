import Foundation



public protocol OAuthToken: Codable, Sendable {
  var endpoint: URL { get set }
  
  var accessToken: AccessTokenClaim? { get set }
  
  var expiresIn: ExpiresInClaim? { get set }
  
  var refreshToken: RefreshTokenClaim? { get set }
  
  var scope: ScopeClaim { get set }
  
  var tokenType: TokenTypeClaim? { get set }
  
  func verify() async throws
 
  @discardableResult
  func mergeable<Token>(_ other: inout Token)
  async throws -> Token where Token: OAuthToken
}


@dynamicMemberLookup
public protocol OAuthServiceable: Actor, Sendable {
  var id: OAuthIdentifier { get }
  
  var token: [String: OAuthToken] { get set }
  var head: (OAuthToken)? { get set }
  
  func authenticationURL() async throws -> URL
  func tokenURL(code: String) async throws -> URL
}


extension OAuthServiceable {
  var head: (OAuthToken)? { nil }
 
  @discardableResult
  public func add(_ token: OAuthToken, isHead: Bool = false) throws -> Self {
    guard token.scope.value.count == 1
    else { throw OAuthError.invalidToken( "pe.value.first!)") }
    
    let scope = token.scope.value.first!
    if self.token[scope] != nil {
      print("Warning: Overwriting existing OAuth Token implementation: '\(scope)'.") }
    self.token[scope] = token
    self.head = token
    
    return self
  }
  
  
  @discardableResult
  public func use(_ head: String) throws -> Self {
    if let token = self.token[head] {
      self.head = token
    }
    
    return self
  }
  
  
  subscript<T>(dynamicMember member: String) -> T? where T: OAuthToken {
    switch member {
    default:
      return self.token[member] as? T
    }
  }
  
  
  subscript<T>(dynamicMember member: String, _ value: T) -> T where T: OAuthToken {
    get { self.token[member] as! T }
    set { self.token[member] = newValue }
  }
}

