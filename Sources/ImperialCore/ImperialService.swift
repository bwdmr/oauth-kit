import Vapor


public protocol ImperialService: Sendable {
  var req: Request { get set }
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
  
  public init(
    req: Request,
    authURL: URL,
    flowURL: URL,
    clientID: String,
    clientSecret: String,
    redirectURI: String,
    callback: @escaping (Request, ImperialBody) async throws -> Void
  ) throws {
    let authScheme = try authURL.scheme.value(or: Abort(.notFound))
    let authHost = try authURL.host.value(or: Abort(.notFound))
    let authPath = authURL.path
    
    let token = ImperialToken(
      scheme: authScheme,
      host: authHost,
      path: authPath,
      clientID: clientID,
      clientSecret: clientSecret,
      redirectURI: redirectURI,
      callback: callback )
    
    self.req = req
    self.authURL = authURL
    self.flowURL = flowURL
    self.token = token
  }
  
  
  mutating func configureauthorizationgrantRoute(on req: Request) throws {
    let app = req.application
    var authorizationtokenBody = token.body
    
    guard let redirectURI = authorizationtokenBody.redirectURI
    else { throw Abort(.notFound) }
    
    let authorizationpathComponents = redirectURI.pathComponents
    app.get(authorizationpathComponents) { request -> Response in
      let authorizationtokenKey = "code"
      let requestqueryCode: String = try request.query.get(at: authorizationtokenKey)
      let scheme = try authURL.scheme.value(or: Abort(.notFound))
      let host = try authURL.host.value(or: Abort(.notFound))
      let path = try authURL.path
      
      authorizationtokenBody.code = requestqueryCode
      token.scheme = scheme
      token.host = host
      token.path = path
      token.body = authorizationtokenBody
      
      try await token.authorizationcodegrantFlow(req: req, body: authorizationtokenBody)
      return Response(status: .ok)
    }
  }
  
  
  mutating func configurerefreshgrantRoute(on req: Request) throws {
    let app = req.application
    var authorizationtokenBody = token.body
    
    guard let redirectURI = authorizationtokenBody.redirectURI
    else { throw Abort(.notFound) }
    
    let authenticationpathComponents = redirectURI.pathComponents
    app.get(authenticationpathComponents) { request -> Response in
      let authenticationtokenKey = "code"
      let requestqueryCode: String = try request.query.get(at: authenticationtokenKey)
      let scheme = try flowURL.scheme.value(or: Abort(.notFound))
      let host = try flowURL.host.value(or: Abort(.notFound))
      let path = try flowURL.path
      
      authorizationtokenBody.code = requestqueryCode
      token.body = authorizationtokenBody
      token.scheme = scheme
      token.host = host
      token.path = path
      
      try await token.refreshtokengrantFlow(req: req, body: authorizationtokenBody)
      return Response(status: .ok)
    }
  }
}



