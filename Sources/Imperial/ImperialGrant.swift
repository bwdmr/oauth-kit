import Vapor


public protocol Grantable { }


public protocol Grantor: Sendable {
  associatedtype T
  
  @Sendable func approve(req: Request, token: T?) async throws -> Void
  @Sendable func revoke(req: Request, token: T?) async throws -> Void
}


public protocol ImperialGrantable: Sendable, Grantable {
  associatedtype T
  associatedtype U
  
  var name: String { get }
  var scheme: String { get set }
  var host: String { get set }
  var path: String { get set }
  var handler: (@Sendable (Request, U?) async throws -> Void)? { get set }
  
  init(
    name: String,
    scheme: String,
    host: String,
    path: String,
    handler: (@Sendable (Request, U?) async throws -> Void)? )
 
  @Sendable func generateURI(payload: T) throws -> URI
  @Sendable func flow(req: Request, data: Data?) async throws -> Void
}
 
extension ImperialGrantable {
  init?(
    name: String,
    url: URL,
    handler: (@Sendable (Request, U?) async throws -> Void)? = nil
  ) throws {
    guard
      let scheme = url.scheme,
      let host = url.host
    else { throw Abort(.notFound) }
    let path = url.path
    
    self.init(
      name: name,
      scheme: scheme,
      host: host,
      path: path,
      handler: handler 
    )
  }
}


