import Foundation



public protocol OAuthToken: Codable, Sendable {
  var endpoint: URL? { get set }
  
  var accessToken: AccessTokenClaim? { get set }
  
  var expiresIn: ExpiresInClaim? { get set }
  
  var refreshToken: RefreshTokenClaim? { get set }
  
  var scope: ScopeClaim? { get set }
  
  var tokenType: TokenTypeClaim? { get set }
  
  func verify() async throws
 
  @discardableResult
  func mergeable<Token>(_ other: inout Token)
  async throws -> Token where Token: OAuthToken
}


///
@dynamicMemberLookup
public protocol OAuthServiceable: Actor, Sendable {
  var id: OAuthIdentifier { get }
  
  var token: [String: OAuthToken] { get set }
  var head: (OAuthToken)? { get set }
  
  var redirectURI: RedirectURIClaim { get }
  
  func authenticationURL() async throws -> URL
  func tokenURL(code: String) async throws -> (URL, [UInt8])
  
  func queryitemBuffer(_ items: [URLQueryItem]) throws -> [UInt8]
}


///
extension OAuthServiceable {
  var head: (OAuthToken)? { nil }

  ///
  @discardableResult
  public func add(_ token: OAuthToken) throws -> Self {
    
    guard 
      let scopeList = token.scope,
      scopeList.value.count == 1
    else { throw OAuthError.invalidToken("Can't configure multiple scopes on a single token") }
    
    
    let scope = scopeList.value.first!
    if self.token[scope] != nil {
      print("Warning: Overwriting existing OAuth Token implementation: '\(scope)'.") }
    self.token[scope] = token
    
    return self
  }
  
  ///
  @discardableResult
  public func add<HeadToken>(_ token: [OAuthToken], head: HeadToken)
  throws -> Self where HeadToken: OAuthToken {
    for token in token { try self.add(token) }
    self.head = head
    
    return self
  }
  
  
  ///
  subscript<T>(dynamicMember member: String) -> T? where T: OAuthToken {
    switch member {
    default:
      return self.token[member] as? T
    }
  }
  
  
  ///
  subscript<T>(dynamicMember member: String, _ value: T) -> T where T: OAuthToken {
    get { self.token[member] as! T }
    set { self.token[member] = newValue }
  }
  
 
  ///
  public func queryitemBuffer(_ items: [URLQueryItem]) throws -> [UInt8] {
    let bodyString = try items.map({
      let key = $0.name
      guard let value = $0.value?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
        throw OAuthError.invalidData("tokenURL query item") }
      return String(describing: "\(key)=\(value)")
    }).joined(separator: "&")
        
    guard let bodyData = bodyString.data(using: .utf8) 
    else { throw OAuthError.invalidData("conversion error") }
    
    let buffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: bodyData.count)
    defer { buffer.deallocate() }
    let _ = bodyData.copyBytes(to: buffer)
    
    return [UInt8](buffer)
  }
}

