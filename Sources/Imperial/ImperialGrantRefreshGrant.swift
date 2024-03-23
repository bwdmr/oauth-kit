/// This approach is suitable for client and server applications that need long-lived access to resources.
/// ex.: Applications with long sessions or access to resources even when the authority is not available.
import Vapor


public struct RefreshGrant: ImperialGrant, ImperialGrantCache {
  public var scheme: String
  public var host: String
  public var path: String
  public var body: ImperialToken
  public var handler: (@Sendable (Vapor.Request, ImperialToken) async throws -> Void)?
  
  private enum CodingKeys: String, CodingKey {
    case scheme = "scheme"
    case host = "host"
    case path = "path"
    case body = "body"
  }
 
  public init(
    scheme: String,
    host: String,
    path: String,
    body: ImperialToken,
    handler: (@Sendable (Vapor.Request, ImperialToken) async throws -> Void)? = nil
  ) {
    self.scheme = scheme
    self.host = host
    self.path = path
    self.body = body
    self.handler = handler
  }
  
  public init(
    scheme: String,
    host: String,
    path: String,
    clientID: String,
    clientSecret: String,
    grantType: String? = nil,
    refreshToken: String,
    callback: (@Sendable (Vapor.Request, ImperialToken) async throws -> Void)? = nil
  ) {
    let refreshtokenBody = ImperialToken(
      clientID: clientID,
      clientSecret: clientSecret,
      grantType: grantType,
      refreshToken: refreshToken)
    self.init(scheme: scheme, host: host, path: path, body: refreshtokenBody, handler: callback)
  }

  public struct RequestBody: Sendable, Codable {
    public var clientID: String
    public var clientSecret: String
    public var grantType: String?
    public var refreshToken: String
    
    private enum CodingKeys: String, CodingKey {
      case clientID = "client_id"
      case clientSecret = "client_secret"
      case grantType = "grant_type"
      case refreshToken = "refresh_token"
    }
    
    init(
      clientID: String,
      clientSecret: String,
      grantType: String?,
      refreshToken: String
    ){
      self.clientID = clientID
      self.clientSecret = clientSecret
      self.grantType = grantType
      self.refreshToken = refreshToken
    }
  }
  
  public mutating func flow(req: Request, body: ImperialToken) async throws {
    let refreshtokengranttypeName = "refresh_token"
    let grantType = body.grantType ?? refreshtokengranttypeName
    
    guard
      let _ = body.clientID,
      let _ = body.clientSecret,
      let _ = body.refreshToken,
      grantType == refreshtokengranttypeName
    else { throw Abort(.internalServerError) }
    
    var components = URLComponents()
    components.scheme = self.scheme
    components.host = self.host
    components.path = self.path
    components.queryItems = [
      self.body.clientIDItem,
      self.body.clientSecretItem,
      self.body.grantTypeItem,
      self.body.refreshTokenItem ]
    
    guard let url = components.url else { throw Abort(.notFound) }
    let urlString = url.absoluteString
    let uri = URI(string: urlString)
    let refreshtokenResponse = try await req.client.post(uri, beforeSend: { req in
      req.headers.contentType = .urlEncodedForm
      try req.content.encode(body)
    }).encodeResponse(for: req)
    
    guard let refreshtokenresponsebodyData = refreshtokenResponse.body.data else { throw Abort(.notFound) }
    let refreshtokenBody = try JSONDecoder().decode(ImperialToken.self, from: refreshtokenresponsebodyData)
    try await callback(req: req, body: refreshtokenBody)
  }
}
