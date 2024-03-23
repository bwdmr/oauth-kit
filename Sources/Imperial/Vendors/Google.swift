/// - See Also:
/// [Access Flow](https://developers.google.com/identity/protocols/oauth2/javascript-implicit-flow#oauth-2.0-endpoints)
/// [Authorization Flow](https://developers.google.com/identity/protocols/oauth2/web-server#httprest_1)
import Vapor
import Imperial


extension ImperialID {
  public static let google = ImperialID("google")
}


extension ImperialFactory {
  public var google: ImperialService {
    guard let result = make(.google) as? (any ImperialService) else {
      fatalError("Google Registry is not configured") }
    return result
  }
}


public struct GoogleService: ImperialService {
  public var req: Vapor.Request
  public var url: URL
  public var grants: [String : @Sendable (String) -> ImperialGrant]
  
  public init(
    req: Vapor.Request,
    url: URL,
    grants: [String : @Sendable (String) -> (ImperialGrant)]
  ) {
    self.req = req
    self.url = url
    self.grants = grants
  }
  
  static public func googleserviceURL() throws -> URL {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "oauth2.googleapis.com"
    urlComponents.path = "/token"
    
    guard let url = urlComponents.url else { throw Abort(.notFound) }
    return url
  }
  
//  init(
//    req: Request,
//    url: URL,
//    clientID: String,
//    clientSecret: String,
//    grantType: String? = nil,
//    redirectURI: String,
//    responseType: String,
//    scope: [String],
//    callback: (@Sendable (Request, ImperialToken) async throws -> Void)?
// ) throws {
//   let googleserviceURL = try GoogleService.googleserviceURL()
//   
//   let callback = { @Sendable (req: Request, body: ImperialToken) async throws in
//     print("function") }
//    
//   try self.init(
//    req: req,
//    url: googleserviceURL,
//    clientID: clientID,
//    clientSecret: clientSecret,
//    grantType: grantType,
//    redirectURI: redirectURI,
//    responseType: responseType,
//    scope: scope,
//    callback: callback)
//  }
}
