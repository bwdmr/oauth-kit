import Vapor


public protocol ImperialService: Sendable {
  var req: Request { get set }
  var clientID: String { get set }
  var clientSecret: String { get set }
  var redirectURI: String { get set }
  var authURL: URL { get set }
  var flowURL: URL { get set }
  
  var token: GenericImperialToken { get set }
  
  init(
    req: Vapor.Request,
    authURL: URL,
    flowURL: URL,
    clientID: String,
    clientSecret: String,
    redirectURI: String,
    callback: @escaping (Request, ImperialBody) async throws -> Void
  )
}


extension ImperialService {
  init(
    req: Request,
    authURL: URL,
    flowURL: URL,
    clientID: String,
    clientSecret: String,
    redirectURI: URL,
    callback: @escaping (Request, ImperialBody) async throws -> Void
  ) throws {
    self.req = req
    
    let redirectURIString = redirectURI.absoluteString
    
    let imperialBody = ImperialBody(
      clientID: clientID,
      clientSecret: clientSecret,
      redirectURI: redirectURIString )
    
    let scheme = try redirectURI.scheme.value(or: Abort(.notFound))
    let host = try redirectURI.host.value(or: Abort(.notFound))
    let path = redirectURI.path
  }
  
  
  mutating func configureauthorizationgrantRoute(with redirectURI: URL, on req: Request) throws {
    let app = req.application
    var authorizationtokenBody = token.body
    
    guard let redirectURI = authorizationtokenBody.redirectURI
    else { throw Abort(.notFound) }
    
    let authorizationpathComponents = redirectURI.pathComponents
    app.get(authorizationpathComponents) { request -> Response in
      let authorizationtokenKey = "code"
      
      let requestqueryCode: String = try request.query.get(at: authorizationtokenKey)
      authorizationtokenBody.code = requestqueryCode
      token.body = authorizationtokenBody
      
      try await token.authorizationcodegrantFlow(req: req, body: authorizationtokenBody)
      return Response(status: .ok)
    }
  }
  
  
  mutating func configurerefreshgrantRoute(with redirectURI: URL, on req: Request) throws {
    let app = req.application
    var authorizationtokenBody = token.body
    
    guard let redirectURI = authorizationtokenBody.redirectURI
    else { throw Abort(.notFound) }
    
    let authenticationpathComponents = redirectURI.pathComponents
    app.get(authenticationpathComponents) { request -> Response in
      let authenticationtokenKey = "code"
      
      let requestqueryCode: String = try request.query.get(at: authenticationtokenKey)
      authorizationtokenBody.code = requestqueryCode
      token.body = authorizationtokenBody
      
      try await token.refreshtokengrantFlow(req: req, body: authorizationtokenBody)
      return Response(status: .ok)
    }
  }
}



