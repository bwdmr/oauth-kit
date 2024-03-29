/// This approach is suitable for client and server applications that need long-lived access to resources.
/// ex.: Applications with long sessions or access to resources even when the authority is not available.
import Vapor



struct RefreshGrant<
  T: OAuthToken,
  U: OAuthToken
>: OAuthGrantable {
  var name: String
  var scheme: String
  var host: String
  var path: String
  var handler: (@Sendable (Vapor.Request, U?) async throws -> Void)?
  
  public func generateURI(payload: T) throws -> URI {
    guard
      let clientID = payload.clientID,
      let clientSecret = payload.clientSecret,
      let refreshToken = payload.refreshToken
    else { throw Abort(.internalServerError) }
    
    var components = URLComponents()
    components.scheme = self.scheme
    components.host = self.host
    components.path = self.path
    components.queryItems = {
      var queryitemList = [
        URLQueryItem(name: ClientIDClaim.key.stringValue, value: clientID.value),
        URLQueryItem(name: ClientSecretClaim.key.stringValue, value: clientSecret.value),
        URLQueryItem(name: RefreshTokenClaim.key.stringValue, value: refreshToken.value)
      ]
      
      return queryitemList
    }()
    
    guard let url = components.url else { throw Abort(.notFound) }
    let urlString = url.absoluteString
    let uri = URI(string: urlString)
    return uri
  }
  
  
  public func grant(req: Request, data: Data?) async throws {
    guard let data = data else { throw Abort(.notFound) }
    let tokenBody = try JSONDecoder().decode(U.self, from: data)
    guard let handler = handler else { throw Abort(.notFound) }
    try await handler(req, tokenBody)
  }
}
