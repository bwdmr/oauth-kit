import Vapor

public protocol OAuthService: Sendable {
  var req: Request { get }
  var grantor: any Grantor { get }
  var grants: Dictionary<String, any OAuthGrantable> { get }
  
  init(
    req: Vapor.Request, 
    grantor: any Grantor,
    grants: [any OAuthGrantable]
  )
  
  func use(_ id: String) throws -> any OAuthGrantable
}


extension OAuthService {
  public func use(_ id: String) throws -> any OAuthGrantable {
    guard let grant = self.grants[id]
    else { throw Abort(.notFound) }
    return grant
  }
}


