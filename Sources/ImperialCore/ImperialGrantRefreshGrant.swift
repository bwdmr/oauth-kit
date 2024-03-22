/// This approach is suitable for client and server applications that need long-lived access to resources.
/// ex.: Applications with long sessions or access to resources even when the authority is not available.
import Vapor
extension ImperialGrant {
  
  func refreshToken(req: Request, body: ImperialToken) async throws -> ImperialToken {
    let refreshtokengranttypeName = "refresh_token"
    let grantType = body.grantType ?? refreshtokengranttypeName
    
    guard
      let _ = body.clientID,
      let _ = body.clientSecret,
      let _ = body.refreshToken,
      grantType == refreshtokengranttypeName
    else { throw Abort(.internalServerError) }
    
    var components = URLComponents()
    components.scheme = self.scheme
    components.host = self.host
    components.path = self.path
    components.queryItems = [
      self.body.clientIDItem,
      self.body.clientSecretItem,
      self.body.grantTypeItem,
      self.body.refreshTokenItem ]
    
    guard let url = components.url else { throw Abort(.notFound) }
    let urlString = url.absoluteString
    let uri = URI(string: urlString)
    let refreshtokenResponse = try await req.client.post(uri, beforeSend: { req in
      req.headers.contentType = .urlEncodedForm
      try req.content.encode(body)
    }).encodeResponse(for: req)
    
    guard let refreshtokenresponsebodyData = refreshtokenResponse.body.data else { throw Abort(.notFound) }
    let refreshtokenBody = try JSONDecoder().decode(ImperialToken.self, from: refreshtokenresponsebodyData)
    return refreshtokenBody
  }
  
  public func refreshtokenFlow(req: Request, body: ImperialToken) async throws {
    let refreshtokenBody = try await refreshToken(req: req, body: body)
    try await callback(req: req, body: refreshtokenBody)
  }
  
}
