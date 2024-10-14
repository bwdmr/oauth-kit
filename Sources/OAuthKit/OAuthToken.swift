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
public protocol OAuthServiceable: Actor, Sendable {
  
  var id: OAuthIdentifier { get }
  
  var token: OAuthToken { get set }
  
  var redirectURI: RedirectURIClaim { get }
  
  func authenticationURL() async throws -> URL
  
  func tokenURL(code: String) async throws -> (URL, [UInt8])
  
  func queryitemBuffer(_ items: [URLQueryItem]) throws -> [UInt8]
}


///
extension OAuthServiceable {
  public func queryitemBuffer(_ items: [URLQueryItem]) throws -> [UInt8] {
    let bodyString = try items.map({
      let key = $0.name
      guard let value = $0.value?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
        throw OAuthError.invalidData("tokenURL query item") }
      return String(describing: "\(key)=\(value)")
    }).joined(separator: "&")
        
    let bodyData = Array(bodyString.utf8)
    return bodyData
  }
}

