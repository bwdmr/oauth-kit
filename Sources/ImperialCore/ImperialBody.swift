import Vapor


public protocol GenericImperialBody: Sendable, Codable, Content {
  var accessToken: String? { get set }
  var clientID: String? { get set }
  var clientSecret: String? { get set }
  var code: String? { get set }
  var error: String? { get set }
  var grantType: String? { get set }
  var redirectURI: String? { get set }
  var refreshToken: String? { get set }
  var responseType: String? { get set }
  var scope: [String]? { get set }
}


extension GenericImperialBody {
  public var accessTokenItem: URLQueryItem {
    .init(name: "access_token", value: self.accessToken) }
  
  public var clientIDItem: URLQueryItem {
    .init(name: "client_id", value: self.clientID) }
  
  public var clientSecretItem: URLQueryItem {
    .init(name: "client_secret", value: self.clientSecret) }
  
  public var codeItem: URLQueryItem {
    .init(name: "code", value: self.code ) }
  
  public var errorItem: URLQueryItem {
    .init(name: "error", value: self.error) }
  
  public var grantTypeItem: URLQueryItem {
    .init(name: "grant_type", value: self.grantType) }
  
  public var redirectURIItem: URLQueryItem {
    .init(name: "redirect_uri", value: self.redirectURI) }
  
  public var refreshTokenItem: URLQueryItem {
    .init(name: "refresh_token", value: self.refreshToken) }
  
  public var responseTypeItem: URLQueryItem {
    .init(name: "response_type", value: self.responseType) }
  
  public var scopeItem: URLQueryItem {
    .init(name: "scope", value: self.scope?.joined(separator: " ")) }
}


public struct ImperialBody: GenericImperialBody {
  public var accessToken: String?
  public var clientID: String?
  public var clientSecret: String?
  public var code: String?
  public var error: String?
  public var grantType: String?
  public var redirectURI: String?
  public var refreshToken: String?
  public var responseType: String?
  public var scope: [String]?
  
  private enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case clientID = "client_id"
    case clientSecret = "client_secret"
    case code = "code"
    case error = "error"
    case grantType = "grant_type"
    case redirectURI = "redirect_uri"
    case refreshToken = "refresh_token"
    case responseType = "response_type"
    case scope = "scope"
  }
}


extension Request {
  
  public func set<A>(_ instance: A)
  where A: GenericImperialBody
  {
    self.cache[A.self] = instance
  }
  
  @discardableResult public func require<A>(_ type: A.Type = A.self) throws -> A
  where A: GenericImperialBody
  {
    guard let a = self.get(A.self) else {
      throw Abort(.unauthorized)
    }
    return a
  }
  
  public func get<A>(_ type: A.Type = A.self) -> A?
  where A: GenericImperialBody
  {
    return self.cache[A.self]
  }
  
  public func has<A>(_ type: A.Type = A.self) -> Bool
  where A: GenericImperialBody
  {
    return self.get(A.self) != nil
  }
  
  private final class Cache {
    private var storage: [ObjectIdentifier: Any]
    
    init() { self.storage = [:] }
    
    internal subscript<A>(_ type: A.Type) -> A?
    where A: GenericImperialBody
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


