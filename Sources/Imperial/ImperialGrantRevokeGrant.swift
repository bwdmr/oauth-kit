/// See Also:
/// - [Revoke Flow](https://developers.google.com/identity/protocols/oauth2/web-server#httprest_3)
import Vapor


public struct RevokeGrant: ImperialGrant, ImperialGrantCache {
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
    token: String,
    callback: (@Sendable (Vapor.Request, ImperialToken) async throws -> Void)? = nil
  ) {
    let revoketokenBody = ImperialToken(token: token)
    self.init(scheme: scheme, host: host, path: path, body: revoketokenBody, handler: callback)
  }

  public struct RequestBody: Sendable, Codable {
    public var token: String
    
    init(token: String){
      self.token = token
    }
    
    private enum CodingKeys: String, CodingKey {
      case token = "token"
    }
  }
  
  public mutating func flow(req: Request, body: ImperialToken) async throws {
    guard
      let _ = body.token
    else { throw Abort(.internalServerError) }
    
    var components = URLComponents()
    components.scheme = self.scheme
    components.host = self.host
    components.path = self.path
    components.queryItems = [
      self.body.tokenItem ]
    
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
