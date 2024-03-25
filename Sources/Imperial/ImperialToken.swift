import Vapor


public protocol _ImperialToken: Sendable, Codable, Content {}

public protocol GenericImperialToken: Sendable, Codable, Content {
  var accessToken: String? { get set }
  var clientID: String? { get set }
  var clientSecret: String? { get set }
  var code: String? { get set }
  var error: String? { get set }
  var grantType: String? { get set }
  var includegrantedScopes: String? { get set }
  var redirectURI: String? { get set }
  var refreshToken: String? { get set }
  var responseType: String? { get set }
  var scope: [String]? { get set }
  var state: String? { get set }
  var token: String? { get set }
  var tokenType: String? { get set }
}

extension GenericImperialToken {
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
  
  public var includegrantedScopesItem: URLQueryItem {
    .init(name: "include_granted_scopes", value: self.includegrantedScopes) }
  
  public var redirectURIItem: URLQueryItem {
    .init(name: "redirect_uri", value: self.redirectURI) }
  
  public var refreshTokenItem: URLQueryItem {
    .init(name: "refresh_token", value: self.refreshToken) }
  
  public var responseTypeItem: URLQueryItem {
    .init(name: "response_type", value: self.responseType) }
  
  public var scopeItem: URLQueryItem {
    .init(name: "scope", value: self.scope?.joined(separator: " ")) }
  
  public var stateItem: URLQueryItem {
    .init(name: "state", value: self.state) }
  
  public var tokenItem: URLQueryItem {
    .init(name: "token", value: self.token) }
  
  public var tokentypeItem: URLQueryItem {
    .init(name: "token_type", value: self.tokenType) }
}


public struct ImperialToken: GenericImperialToken {
  public var accessToken: String?
  public var clientID: String?
  public var clientSecret: String?
  public var code: String?
  public var error: String?
  public var grantType: String?
  public var includegrantedScopes: String?
  public var redirectURI: String?
  public var refreshToken: String?
  public var responseType: String?
  public var scope: [String]?
  public var state: String?
  public var token: String?
  public var tokenType: String?
  
  private enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case clientID = "client_id"
    case clientSecret = "client_secret"
    case code = "code"
    case error = "error"
    case grantType = "grant_type"
    case includegrantedScopes = "include_granted_scopes"
    case redirectURI = "redirect_uri"
    case refreshToken = "refresh_token"
    case responseType = "response_type"
    case scope = "scope"
    case state = "state"
    case token = "token"
    case tokenType = "token_type"
  }
}


extension Request {
  
  public func approve<A>(_ instance: A)
  where A: GenericImperialToken
  {
    self.cache[A.self] = instance
  }
  
  public func revoke<A>(_ type: A.Type = A.self)
  where A: GenericImperialToken
  {
    self.cache[A.self] = nil
  }
  
  @discardableResult public func require<A>(_ type: A.Type = A.self) throws -> A
  where A: GenericImperialToken
  {
    guard let a = self.get(A.self) else {
      throw Abort(.unauthorized)
    }
    return a
  }
  
  public func get<A>(_ type: A.Type = A.self) -> A?
  where A: GenericImperialToken
  {
    return self.cache[A.self]
  }
  
  public func has<A>(_ type: A.Type = A.self) -> Bool
  where A: GenericImperialToken
  {
    return self.get(A.self) != nil
  }
  
  private final class Cache {
    private var storage: [ObjectIdentifier: Any]
    
    init() { self.storage = [:] }
    
    internal subscript<A>(_ type: A.Type) -> A?
    where A: GenericImperialToken
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


