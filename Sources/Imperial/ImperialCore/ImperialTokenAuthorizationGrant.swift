import Vapor

/// This approach is suitable for client applications that don't need long-lived access to resources
/// or when the resource server doesn't support or want to issue refresh tokens.
/// ex.: Federated Login or access to regulated and/or compliance requirement-related data.

extension GenericImperialToken {
  
  mutating private func authorizationcodeGrant(req: Request, body: ImperialBody) async throws -> ImperialBody {
    let authorizationcodeGrant = "authorization_code"
    
    guard
      let clientID = body.clientID,
      let clientSecret = body.clientSecret,
      let redirectURI = body.redirectURI,
      let code = body.code,
      let grantType = body.grantType,
      grantType == authorizationcodeGrant
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
    
    let url = try components.url.value(or: Abort(.notFound))
    let urlString = url.absoluteString
    let uri = URI(string: urlString)
    let accesstokenResponse = try await req.client.post(uri, beforeSend: { req in
      req.headers.contentType = .urlEncodedForm
      try req.content.encode(body)
    }).encodeResponse(for: req)
    
    let accesstokenresponsebodyData = try accesstokenResponse.body.data.value(or: Abort(.notFound))
    let accesstokenBody = try JSONDecoder().decode(ImperialBody.self, from: accesstokenresponsebodyData)
    return accesstokenBody
  }

  mutating public func authorizationcodegrantFlow(req: Request, body: ImperialBody) async throws {
    let accesstokenBody = try await authorizationcodeGrant(req: req, body: body)
    try await callback(req: req, body: accesstokenBody)
  }
}
