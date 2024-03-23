import Vapor


public protocol ImperialGrant: Codable, Sendable {
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
  
  mutating func flow(req: Request, body: ImperialToken) async throws
}

public protocol ImperialGrantCache {
  var handler: (@Sendable (Request, ImperialToken) async throws -> Void)? { get set }
  func callback(req: Request, body: ImperialToken) async throws
}

extension ImperialGrantCache {

  public func callback(req: Request, body: ImperialToken) async throws {
    req.set(body)
    
    if let handler = handler {
      try await handler(req, body)
    }
  }
}
