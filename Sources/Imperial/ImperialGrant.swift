import Vapor


public protocol Grantable { }

public protocol Grantor: Sendable { }

public protocol ImperialGrantable: Sendable, Grantable {
  var scheme: String { get set }
  var host: String { get set }
  var path: String { get set }
  var responseBody: ImperialToken { get }
  var handler: (@Sendable (Request, ImperialToken) async throws -> Void) { get }
  
  init(
    scheme: String,
    host: String,
    path: String,
    handler: (@Sendable (Request, ImperialToken) async throws -> Void)
  )
  
  @Sendable func flow(req: Request, body: ImperialToken) async throws
}


