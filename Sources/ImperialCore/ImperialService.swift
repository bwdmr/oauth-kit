import Vapor


public protocol ImperialService: Sendable {
  var req: Request { get }
  var url: URL { get }
  var grants: [String: @Sendable (String) -> ImperialGrant] { get set }
  
  init(
    req: Vapor.Request,
    url: URL,
    grants: [String: @Sendable (String) -> (any ImperialGrant)]
  )
}

extension ImperialService {
  init(
    req: Vapor.Request,
    url: URL,
    clientID: String,
    clientSecret: String,
    grantType: String? = nil,
    redirectURI: String,
    responseType: String,
    scope: [String],
    callback: (@Sendable (Request, ImperialToken) async throws -> Void)?
  ) throws {
    guard
      let scheme = url.scheme,
      let host = url.host
    else { throw Abort(.notFound) }
    let path = url.path

    let authorizationGrant = {(code: String) -> ImperialGrant in
      AuthorizationGrant(
        scheme: scheme,
        host: host,
        path: path,
        clientID: clientID,
        clientSecret: clientSecret,
        code: code,
        grantType: grantType,
        redirectURI: redirectURI,
        callback: callback )}
    
    let refreshGrant = {(refreshToken: String) -> ImperialGrant in
      RefreshGrant(
        scheme: scheme,
        host: host, 
        path: path,
        clientID: clientID,
        clientSecret: clientSecret,
        grantType: grantType,
        refreshToken: refreshToken,
        callback: callback )}
    
    let revokeGrant = {(token: String) -> ImperialGrant in
      RevokeGrant( 
        scheme: scheme,
        host: host,
        path: path,
        token: token,
        callback: callback )}
    
    let grants = [
      "authorization": authorizationGrant,
      "refresh": refreshGrant,
      "revoke": revokeGrant ]
    
    self.init(req: req, url: url, grants: grants)
  }
}

//
//extension GenericImperialService {
//  func configureauthorizationgrantRoute(on req: Request) throws {
//    let app = req.application
//    var authorizationtokenBody = token.body
//    
//    guard let redirectURI = authorizationtokenBody.redirectURI
//    else { throw Abort(.notFound) }
//    
//    let redirecturipathComponents = redirectURI.pathComponents
//    app.get(redirecturipathComponents) { request -> Response in
//      let authorizationtokenKey = "code"
//      let requestqueryCode: String = try request.query.get(at: authorizationtokenKey)
//      
//      guard
//        let scheme = self.url.scheme,
//        let host = self.url.host
//      else { throw Abort(.notFound) }
//      let path = self.url.path
//      
//      authorizationtokenBody.code = requestqueryCode
//      self.token.scheme = scheme
//      self.token.host = host
//      self.token.path = path
//      self.token.body = authorizationtokenBody
//      
//      try await self.token.authorizationtokenFlow(req: req, body: authorizationtokenBody)
//      return Response(status: .ok)
//    }
//  }
//}
