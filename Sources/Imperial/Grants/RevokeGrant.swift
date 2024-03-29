/// See Also:
/// - [Revoke Flow](https://developers.google.com/identity/protocols/oauth2/web-server#httprest_3)
import Vapor



struct RevokeGrant<
  T: ImperialToken,
  U: ImperialToken
>: ImperialGrantable {
  var name: String
  var scheme: String
  var host: String
  var path: String
  var handler: (@Sendable (Vapor.Request, T?) async throws -> Void)?
 
  public func generateURI(payload: T) throws -> URI {
    guard
      let code = payload.code
    else { throw Abort(.notFound) }
    
    var components = URLComponents()
    components.scheme = self.scheme
    components.host = self.host
    components.path = self.path
    components.queryItems = {
      let queryitemList = [
        URLQueryItem(name: TokenClaim.key.stringValue, value: code.value)
      ]
      
      return queryitemList
    }()
    
    guard let url = components.url else { throw Abort(.notFound) }
    let urlString = url.absoluteString
    let uri = URI(string: urlString)
    return uri
  }
  
  
  public func grant(req: Request, data: Data? = nil) async throws {
    guard let handler = handler else { throw Abort(.notFound) }
    try await handler(req, nil)
  }
}
