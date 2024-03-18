import Vapor


public protocol GenericImperialToken {
  var scheme: String { get set }
  var host: String { get set }
  var path: String { get set }
  var body: ImperialBody { get set }
  var handler: @Sendable (Request, ImperialBody) async throws -> Void { get set }
  
  init(
    scheme: String,
    host: String,
    path: String,
    body: ImperialBody,
    handler: @Sendable @escaping (Request, ImperialBody) async throws -> Void
  )
  
  mutating func authorizationcodegrantFlow(req: Request, body: ImperialBody) async throws
  mutating func refreshtokengrantFlow(req: Request, body: ImperialBody) async throws
}

open class ImperialToken: GenericImperialToken {
  public var scheme: String
  public var host: String
  public var path: String
  public var body: ImperialBody
  public var handler: @Sendable (Vapor.Request, ImperialBody) async throws -> Void
  
  public required init(
    scheme: String,
    host: String,
    path: String,
    body: ImperialBody,
    handler: @Sendable @escaping (Vapor.Request, ImperialBody) async throws -> Void
  ) {
    self.scheme = scheme
    self.host = host
    self.path = path
    self.body = body
    self.handler = handler
  }
  
  func callback(req: Request, body: ImperialBody) async throws {
    req.set(body)
    return try await self.handler(req, body)
  }
}

extension ImperialToken {
  convenience init(
    scheme: String,
    host: String,
    path: String,
    clientID: String,
    clientSecret: String,
    redirectURI: String,
    callback: @Sendable @escaping (Request, ImperialBody) async throws -> Void
  ) {
    let imperialtokenBody = ImperialBody(
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

