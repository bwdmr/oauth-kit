import Vapor
import ImperialCore

extension ImperialID {
  public static let google = ImperialID("google")
}


extension ImperialFactory {
  public var google: ImperialService {
    guard let result = make(.google) as? ImperialService else {
      fatalError("Google Registry is not configured") }
    return result
  }
}


public class GoogleService: ImperialService {
  static public func preflightURL() throws -> URL {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "oauth2.googleapis.com"
    urlComponents.path = "/token"
    
    guard let url = urlComponents.url else { throw Abort(.notFound) }
    return url
  }
  
  static public func authorizationgrantURL() throws -> URL {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "oauth2.googleapis.com"
    urlComponents.path = "/token"
    
    guard let url = urlComponents.url else { throw Abort(.notFound) }
    return url
  }
  
  convenience init?(
    req: Request,
    clientID: String,
    clientSecret: String,
    grantType: String? = nil,
    redirectURI: String,
    responseType: String,
    scope: [String]
 ) throws {
   let preflightURL = try GoogleService.preflightURL()
   let authorizationgrantURL = try GoogleService.authorizationgrantURL()
   
   let callback = { @Sendable (req: Request, body: ImperialToken) async throws in
     print("function") }
    
   try self.init(
    req: req,
    preflightURL: preflightURL,
    grantURL: authorizationgrantURL,
    clientID: clientID,
    clientSecret: clientSecret,
    grantType: grantType,
    redirectURI: redirectURI,
    responseType: responseType,
    scope: scope,
    callback: callback)
  }
}
