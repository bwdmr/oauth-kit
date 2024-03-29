import Vapor


public struct OAuthID: Hashable, Codable, Sendable {
  public let value: String
  public init(_ string: String) {
    self.value = string
  }
}


public final class OAuthRegistry {
  public let app: Application
  public var oauthservices: [OAuthID: ((Request) -> OAuthService)]
  
  init(_ app: Application) {
    self.app = app
    self.oauthservices = [:]
  }
 
  fileprivate func router(_ req: Request) -> OAuthFactory {
    .init(req, self)
  }
  
  fileprivate func make(_ id: OAuthID, _ req: Request) -> OAuthService {
    guard let oauthservice = oauthservices[id] else {
      fatalError("Federated service for id '\(id.value)' is not configured.") }
    return oauthservice(req)
  }
  
  public func register(_ id: OAuthID, _ oauthservice: @escaping (Request) -> OAuthService) {
    oauthservices[id] = oauthservice
  }
}


public struct OAuthFactory {
  private var req: Request
  private var registry: OAuthRegistry
  
  init(_ req: Request, _ registry: OAuthRegistry) {
    self.req = req
    self.registry = registry
  }
  
  public func make(_ id: OAuthID) -> OAuthService {
    registry.make(id, req)
  }
}


public extension Application {
  private struct Key: StorageKey {
    typealias Value = OAuthRegistry
  }
  
  var oauthservices: OAuthRegistry {
    if storage[Key.self] == nil {
      storage[Key.self] = .init(self)
    }
    return storage[Key.self]!
  }
}


extension Request {
  var oauthservices: OAuthFactory { application.oauthservices.router(self)}
}
