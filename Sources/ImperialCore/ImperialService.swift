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
      
      guard
        let scheme = self.authURL.scheme,
        let host = self.authURL.host
      else { throw Abort(.notFound) }
      
      let path = self.authURL.path
      
      authorizationtokenBody.code = requestqueryCode
      self.token.scheme = scheme
      self.token.host = host
      self.token.path = path
      self.token.body = authorizationtokenBody
      
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
      
      guard
        let scheme = self.flowURL.scheme,
        let host = self.flowURL.host
      else { throw Abort(.notFound) }
      
      let path = self.flowURL.path
      
      authorizationtokenBody.code = requestqueryCode
      self.token.body = authorizationtokenBody
      self.token.scheme = scheme
      self.token.host = host
      self.token.path = path
      
      try await token.refreshtokengrantFlow(req: req, body: authorizationtokenBody)
      return Response(status: .ok)
    }
  }
}



