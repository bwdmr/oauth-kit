import Vapor


public protocol GenericImperialGrant {
  var scheme: String { get set }
  var host: String { get set }
  var path: String { get set }
  var body: ImperialToken { get set }
  var handler: @Sendable (Request, ImperialToken) async throws -> Void { get set }
  
  init(
    scheme: String,
    host: String,
    path: String,
    body: ImperialToken,
    handler: @Sendable @escaping (Request, ImperialToken) async throws -> Void
  )
  
  mutating func authorizationcodeFlow(req: Request, body: ImperialToken) async throws
  mutating func refreshtokenFlow(req: Request, body: ImperialToken) async throws
}

open class ImperialGrant: GenericImperialGrant {
  public var scheme: String
  public var host: String
  public var path: String
  public var body: ImperialToken
  public var handler: @Sendable (Vapor.Request, ImperialToken) async throws -> Void
  
  public required init(
    scheme: String,
    host: String,
    path: String,
    body: ImperialToken,
    handler: @Sendable @escaping (Vapor.Request, ImperialToken) async throws -> Void
  ) {
    self.scheme = scheme
    self.host = host
    self.path = path
    self.body = body
    self.handler = handler
  }
  
  func callback(req: Request, body: ImperialToken) async throws {
    req.set(body)
    return try await self.handler(req, body)
  }
}

extension ImperialGrant {
  convenience init(
    scheme: String,
    host: String,
    path: String,
    clientID: String,
    clientSecret: String,
    redirectURI: String,
    callback: @Sendable @escaping (Request, ImperialToken) async throws -> Void
  ) {
    let imperialtokenBody = ImperialToken(
      clientID: clientID,
      clientSecret: clientSecret,
      redirectURI: redirectURI )
    
    self.init(
      scheme: scheme,
      host: host,
      path: path,
      body: imperialtokenBody,
      handler: callback)
  }
}

