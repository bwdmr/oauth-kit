import Vapor


public protocol GenericImperialService {
  var req: Request { get }
  var url: URL { get }
  var token: GenericImperialGrant { get set }
  
  init(
    req: Vapor.Request,
    url: URL,
    token: GenericImperialGrant
  )
}


open class ImperialService: GenericImperialService {
  public var req: Vapor.Request
  public var url: URL
  public var token: GenericImperialGrant
  
  public required init(
    req: Vapor.Request,
    url: URL,
    token: GenericImperialGrant
  ) {
    self.req = req
    self.url = url
    self.token = token
  }
  
  public convenience init(
    req: Vapor.Request,
    url: URL,
    clientID: String,
    clientSecret: String,
    grantType: String? = nil,
    redirectURI: String,
    responseType: String,
    scope: [String],
    callback: (@Sendable (Request, ImperialToken) async throws -> Void)? = nil
  ) throws {
    
    guard
      let scheme = url.scheme,
      let host = url.host
    else { throw Abort(.notFound) }
    let path = url.path

    let token = ImperialGrant(
      scheme: scheme,
      host: host,
      path: path,
      clientID: clientID,
      clientSecret: clientSecret,
      grantType: grantType,
      redirectURI: redirectURI,
      responseType: responseType,
      scope: scope,
      callback: callback )
    
    self.init(req: req, url: url, token: token)
  }
  
  
  func configureauthorizationgrantRoute(on req: Request) throws {
    let app = req.application
    var authorizationtokenBody = token.body
    
    guard let redirectURI = authorizationtokenBody.redirectURI
    else { throw Abort(.notFound) }
    
    let redirecturipathComponents = redirectURI.pathComponents
    app.get(redirecturipathComponents) { request -> Response in
      let authorizationtokenKey = "code"
      let requestqueryCode: String = try request.query.get(at: authorizationtokenKey)
      
      guard
        let scheme = self.url.scheme,
        let host = self.url.host
      else { throw Abort(.notFound) }
      let path = self.url.path
      
      authorizationtokenBody.code = requestqueryCode
      self.token.scheme = scheme
      self.token.host = host
      self.token.path = path
      self.token.body = authorizationtokenBody
      
      try await self.token.authorizationtokenFlow(req: req, body: authorizationtokenBody)
      return Response(status: .ok)
    }
  }
}
