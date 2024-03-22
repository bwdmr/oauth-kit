/// See Also:
/// - [Revoke Flow](https://developers.google.com/identity/protocols/oauth2/web-server#httprest_3)
import Vapor
extension ImperialGrant {
  
  func revokeToken(req: Request, body: ImperialToken) async throws -> ImperialToken {
    guard
      let _ = body.token
    else { throw Abort(.internalServerError) }
    
    var components = URLComponents()
    components.scheme = self.scheme
    components.host = self.host
    components.path = self.path
    components.queryItems = [
      self.body.tokenItem ]
    
    guard let url = components.url else { throw Abort(.notFound) }
    let urlString = url.absoluteString
    let uri = URI(string: urlString)
    let refreshtokenResponse = try await req.client.post(uri, beforeSend: { req in
      req.headers.contentType = .urlEncodedForm
      try req.content.encode(body)
    }).encodeResponse(for: req)
    
    let revoketokenresponsebodyData = ImperialToken()
    return revoketokenresponsebodyData
  }
  
  public func revoketokenFlow(req: Request, body: ImperialToken) async throws {
    let revoketokenBody = try await revokeToken(req: req, body: body)
    try await callback(req: req, body: revoketokenBody)
  }
}
