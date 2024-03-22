import Vapor


public protocol GenericImperialGrant {
  var scheme: String { get set }
  var host: String { get set }
  var path: String { get set }
  var body: ImperialToken { get set }
  var handler: (@Sendable (Request, ImperialToken) async throws -> Void)? { get set }
  
  init(
    scheme: String,
    host: String,
    path: String,
    body: ImperialToken,
    handler: (@Sendable (Request, ImperialToken) async throws -> Void)?
  )
  
  mutating func authorizationtokenFlow(req: Request, body: ImperialToken) async throws
  mutating func refreshtokenFlow(req: Request, body: ImperialToken) async throws
  mutating func revoketokenFlow(req: Request, body: ImperialToken) async throws
}



open class ImperialGrant: GenericImperialGrant {
  public var scheme: String
  public var host: String
  public var path: String
  public var body: ImperialToken
  public var handler: (@Sendable (Vapor.Request, ImperialToken) async throws -> Void)?
  
  public required init(
    scheme: String,
    host: String,
    path: String,
    body: ImperialToken,
    handler: (@Sendable (Vapor.Request, ImperialToken) async throws -> Void)?
  ) {
    self.scheme = scheme
    self.host = host
    self.path = path
    self.body = body
    self.handler = handler
  }
  
  func callback(req: Request, body: ImperialToken) async throws {
    req.set(body)
    
    if let handler = handler {
      try await handler(req, body)
    }
  }
}

extension ImperialGrant {
  convenience init(
    scheme: String,
    host: String,
    path: String,
    clientID: String,
    clientSecret: String,
    grantType: String,
    redirectURI: String,
    responseType: String,
    scope: [String],
    callback: (@Sendable (Request, ImperialToken) async throws -> Void)?
  ) {
    let imperialtokenBody = ImperialToken(
      clientID: clientID,
      clientSecret: clientSecret,
      grantType: grantType,
      redirectURI: redirectURI,
      responseType: responseType,
      scope: scope)
    
    self.init(
      scheme: scheme,
      host: host,
      path: path,
      body: imperialtokenBody,
      handler: callback)
  }
}

