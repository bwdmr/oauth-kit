import Vapor


public struct ImperialID: Hashable, Codable, Sendable {
  public let value: String
  public init(_ string: String) {
    self.value = string
  }
}


public final class ImperialRegistry {
  public let app: Application
  public var imperialservices: [ImperialID: ((Request) -> ImperialService)]
  
  init(_ app: Application) {
    self.app = app
    self.imperialservices = [:]
  }
 
  fileprivate func router(_ req: Request) -> ImperialFactory {
    .init(req, self)
  }
  
  fileprivate func make(_ id: ImperialID, _ req: Request) -> ImperialService {
    guard let imperialservice = imperialservices[id] else {
      fatalError("Federated service for id '\(id.value)' is not configured.") }
    return imperialservice(req)
  }
  
  public func register(_ id: ImperialID, _ imperialservice: @escaping (Request) -> ImperialService) {
    imperialservices[id] = imperialservice
  }
}


public struct ImperialFactory {
  private var req: Request
  private var registry: ImperialRegistry
  
  init(_ req: Request, _ registry: ImperialRegistry) {
    self.req = req
    self.registry = registry
  }
  
  public func make(_ id: ImperialID) -> ImperialService {
    registry.make(id, req)
  }
}


public extension Application {
  private struct Key: StorageKey {
    typealias Value = ImperialRegistry
  }
  
  var imperialservices: ImperialRegistry {
    if storage[Key.self] == nil {
      storage[Key.self] = .init(self)
    }
    return storage[Key.self]!
  }
}


extension Request {
  var imperialservices: ImperialFactory { application.imperialservices.router(self)}
}
