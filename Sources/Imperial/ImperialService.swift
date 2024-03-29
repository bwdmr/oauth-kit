import Vapor

public protocol ImperialService: Sendable {
  var req: Request { get }
  var grantor: any Grantor { get }
  var grants: Dictionary<String, any ImperialGrantable> { get }
  
  init(
    req: Vapor.Request, 
    grantor: any Grantor,
    grants: [any ImperialGrantable]
  )
  
  func use(_ id: String) throws -> any ImperialGrantable
}


extension ImperialService {
  public func use(_ id: String) throws -> any ImperialGrantable {
    guard let grant = self.grants[id]
    else { throw Abort(.notFound) }
    return grant
  }
}


