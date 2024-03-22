import Vapor



/// This approach is suitable for client applications that don't need long-lived access to resources
/// or when the resource server doesn't support or want to issue refresh tokens.
/// ex.: Federated Login or access to regulated and/or compliance requirement-related data.

extension ImperialGrant {
  
  func authorizationCode(req: Request, body: ImperialToken) async throws -> ImperialToken {
    let authorizationcodegrantName = "authorization_code"
    
    guard
      let _ = body.clientID,
      let _ = body.clientSecret,
      let _ = body.redirectURI,
      let _ = body.code,
      let grantType = body.grantType,
      grantType == authorizationcodegrantName
    else { throw Abort(.internalServerError) }
    
    var components = URLComponents()
    components.scheme = self.scheme
    components.host = self.host
    components.path = self.path
    components.queryItems = [
      self.body.clientIDItem,
      self.body.clientSecretItem,
      self.body.redirectURIItem,
      self.body.codeItem,
      self.body.grantTypeItem ]
    
    guard let url = components.url else { throw Abort(.notFound) }
    let urlString = url.absoluteString
    let uri = URI(string: urlString)
    let accesstokenResponse = try await req.client.post(uri, beforeSend: { req in
      req.headers.contentType = .urlEncodedForm
      try req.content.encode(body)
    }).encodeResponse(for: req)
    
    guard let accesstokenresponsebodyData = accesstokenResponse.body.data else { throw Abort(.notFound) }
    let accesstokenBody = try JSONDecoder().decode(ImperialToken.self, from: accesstokenresponsebodyData)
    return accesstokenBody
  }

  public func authorizationtokenFlow(req: Request, body: ImperialToken) async throws {
    let accesstokenBody = try await authorizationCode(req: req, body: body)
    try await callback(req: req, body: accesstokenBody)
  }
}
