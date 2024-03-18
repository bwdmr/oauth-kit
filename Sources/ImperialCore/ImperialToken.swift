import Vapor


public protocol GenericImperialToken: Sendable {
  var scheme: String { get set }
  var host: String { get set }
  var path: String { get set }
  var body: ImperialBody { get set }
  var handler: (Request, ImperialBody) async throws -> Void { get set }
  
  init(
    scheme: String,
    host: String,
    path: String,
    clientID: String,
    clientSecret: String,
    redirectURI: String,
    callback: @escaping (Request, ImperialBody) async throws -> Void )
  
  mutating func authorizationcodegrantFlow(req: Request, body: ImperialBody) async throws
  mutating func refreshtokengrantFlow(req: Request, body: ImperialBody) async throws
}


extension GenericImperialToken {
  private func callback(req: Request, body: ImperialBody) async throws {
    req.set(body)
    return try await self.handler(req, body)
  }
}

public struct ImperialToken: GenericImperialToken {
  public var scheme: String
  public var host: String
  public var path: String
  public var body: ImperialBody
  public var handler: (Request, ImperialBody) async throws -> Void
  
  public init(
    scheme: String,
    host: String,
    path: String,
    clientID: String,
    clientSecret: String,
    redirectURI: String,
    callback: @escaping (Request, ImperialBody) async throws -> Void
  ) {
    self.scheme = scheme
    self.host = host
    self.path = path
    
    let imperialtokenBody = ImperialBody(
      clientID: clientID,
      clientSecret: clientSecret,
      redirectURI: redirectURI )
    
    self.body = imperialtokenBody
    self.handler = callback
  }
  
  override func callback(req: Request, body: ImperialBody) async throws {
    
  }
}




