import Vapor


public protocol GenericImperialService {
  var req: Request { get }
  var authURL: URL { get }
  var flowURL: URL { get }
  var token: GenericImperialGrant { get set }
  
  init(
    req: Vapor.Request,
    authURL: URL,
    flowURL: URL,
    token: GenericImperialGrant
  )
}

open class ImperialService: GenericImperialService {
  public var req: Vapor.Request
  public var authURL: URL
  public var flowURL: URL
  public var token: GenericImperialGrant
  
  public required init(
    req: Vapor.Request,
    authURL: URL,
    flowURL: URL,
    token: GenericImperialGrant
  ) {
    self.req = req
    self.authURL = authURL
    self.flowURL = flowURL
    self.token = token
  }
  
  
  public convenience init(
    req: Vapor.Request,
    authURL: URL,
    flowURL: URL,
    clientID: String,
    clientSecret: String,
    redirectURI: String,
    callback: @Sendable @escaping (Request, ImperialToken) async throws -> Void
  ) throws {
    
    guard
      let authScheme = authURL.scheme,
      let authHost = authURL.host
    else { throw Abort(.notFound) }
    
    let authPath = authURL.path

    let token = ImperialGrant(
      scheme: authScheme,
      host: authHost,
      path: authPath,
      clientID: clientID,
      clientSecret: clientSecret,
      redirectURI: redirectURI,
      callback: callback )
    
    self.init(req: req, authURL: authURL, flowURL: flowURL, token: token)
  }
  
  
  func configureauthorizationgrantRoute(on req: Request) throws {
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
      
      try await self.token.authorizationcodeFlow(req: req, body: authorizationtokenBody)
      return Response(status: .ok)
    }
  }

  
  func configurerefreshgrantRoute(on req: Request) throws {
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
      
      try await self.token.refreshtokenFlow(req: req, body: authorizationtokenBody)
      return Response(status: .ok)
    }
  }
}
