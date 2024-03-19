import Vapor



public protocol GenericImperialService {
  var req: Request { get }
  var preflightURL: URL { get }
  var grantURL: URL { get }
  var token: GenericImperialGrant { get set }
  
  init(
    req: Vapor.Request,
    preflightURL: URL,
    grantURL: URL,
    token: GenericImperialGrant
  )
}



open class ImperialService: GenericImperialService {
  public var req: Vapor.Request
  public var preflightURL: URL
  public var grantURL: URL
  public var token: GenericImperialGrant
  
  public required init(
    req: Vapor.Request,
    preflightURL: URL,
    grantURL: URL,
    token: GenericImperialGrant
  ) {
    self.req = req
    self.preflightURL = preflightURL
    self.grantURL = grantURL
    self.token = token
  }
  
  
  public convenience init(
    req: Vapor.Request,
    preflightURL: URL,
    grantURL: URL,
    clientID: String,
    clientSecret: String,
    grantType: String,
    redirectURI: String,
    responseType: String,
    scope: [String],
    callback: (@Sendable (Request, ImperialToken) async throws -> Void)? = nil
  ) throws {
    
    guard
      let preflightScheme = preflightURL.scheme,
      let preflightHost = preflightURL.host
    else { throw Abort(.notFound) }
    
    let preflightPath = preflightURL.path

    let token = ImperialGrant(
      scheme: preflightScheme,
      host: preflightHost,
      path: preflightPath,
      clientID: clientID,
      clientSecret: clientSecret,
      grantType: grantType,
      redirectURI: redirectURI,
      responseType: responseType,
      scope: scope,
      callback: callback )
    
    self.init(req: req, preflightURL: preflightURL, grantURL: grantURL, token: token)
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
        let scheme = self.preflightURL.scheme,
        let host = self.preflightURL.host
      else { throw Abort(.notFound) }
      
      let path = self.preflightURL.path
      
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
        let scheme = self.grantURL.scheme,
        let host = self.grantURL.host
      else { throw Abort(.notFound) }
      
      let path = self.grantURL.path
      
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
