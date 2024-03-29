import Vapor



public struct CacheGrantable<T: ImperialToken, U: ImperialToken>: Grantor {

  @Sendable public func approve(req: Request, token: U?) async throws -> Void {
    guard let token = token else { throw Abort(.notFound) }
    req.approve(token) }
  
  @Sendable public func revoke(req: Request, token: U?) async throws -> Void {
    guard let token = token else { throw Abort(.notFound) }
    req.revoke(type(of: token))
  }
}



extension Request {
  public func approve<A>(_ instance: A)
  where A: ImperialToken
  {
    self.cache[A.self] = instance
  }
  
  public func revoke<A>(_ type: A.Type = A.self)
  where A: ImperialToken
  {
    self.cache[A.self] = nil
  }
  
  @discardableResult public func require<A>(_ type: A.Type = A.self) throws -> A
  where A: ImperialToken
  {
    guard let a = self.get(A.self) else {
      throw Abort(.unauthorized)
    }
    return a
  }
  
  public func get<A>(_ type: A.Type = A.self) -> A?
  where A: ImperialToken
  {
    return self.cache[A.self]
  }
  
  public func has<A>(_ type: A.Type = A.self) -> Bool
  where A: ImperialToken
  {
    return self.get(A.self) != nil
  }
  
  private final class Cache {
    private var storage: [ObjectIdentifier: Any]
    
    init() { self.storage = [:] }
    
    internal subscript<A>(_ type: A.Type) -> A?
    where A: ImperialToken
    {
      get { return storage[ObjectIdentifier(A.self)] as? A }
      set { storage[ObjectIdentifier(A.self)] = newValue }
    }
  }
  
  private struct CacheKey: StorageKey {
    typealias Value = Cache
  }
  
  private var cache: Cache {
    get {
      if let existing = self.storage[CacheKey.self] {
        return existing
      }
      
      else {
        let new = Cache()
        self.storage[CacheKey.self] = new
        return new
      }
    }
    
    set {
      self.storage[CacheKey.self] = newValue
    }
  }
}

