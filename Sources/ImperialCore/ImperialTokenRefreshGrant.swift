import Vapor



/// This approach is suitable for client and server applications that need long-lived access to resources.
/// ex.: Applications with long sessions or access to resources even when the authority is not available.
 
extension GenericImperialToken {
  
  mutating private func refreshtokenGrant(req: Request, body: ImperialBody) async throws -> ImperialBody {
    let refreshtokenScope = "offline_access"
    let refreshtokenGrant = "refresh_token"
    
    guard
      let _ = body.clientID,
      let _ = body.clientSecret,
      let _ = body.redirectURI,
      let _ = body.code,
      let grantType = body.grantType,
      grantType == refreshtokenGrant,
      let scopeList = body.scope,
      scopeList.contains(refreshtokenScope)
    else { throw Abort(.internalServerError) }
    
    var components = URLComponents()
    components.scheme = self.scheme
    components.host = self.host
    components.path = self.path
    components.queryItems = [
      self.body.clientIDItem,
      self.body.clientSecretItem,
      self.body.redirectURIItem,
      self.body.refreshTokenItem,
      self.body.codeItem,
      self.body.grantTypeItem ]
    
    guard let url = components.url else { throw Abort(.notFound) }
    let urlString = url.absoluteString
    let uri = URI(string: urlString)
    let refreshtokenResponse = try await req.client.post(uri, beforeSend: { req in
      req.headers.contentType = .urlEncodedForm
      try req.content.encode(body)
    }).encodeResponse(for: req)
    
    guard let refreshtokenresponsebodyData = refreshtokenResponse.body.data else { throw Abort(.notFound) }
    let refreshtokenBody = try JSONDecoder().decode(ImperialBody.self, from: refreshtokenresponsebodyData)
    return refreshtokenBody
  }
  
  mutating public func refreshtokengrantFlow(req: Request, body: ImperialBody) async throws {
    let accesstokenBody = try await authorizationcodeGrant(req: req, body: body)
    self.body = accesstokenBody
    let refreshtokenBody = try await refreshtokenGrant(req: req, body: body)
    try await callback(req: req, body: refreshtokenBody)
  }
  
}
