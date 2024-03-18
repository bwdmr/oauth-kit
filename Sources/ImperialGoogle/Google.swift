import Vapor
import ImperialCore

extension ImperialID {
  static let google = ImperialID("google")
}


extension ImperialFactory {
  var google: ImperialService {
    guard let result = make(.google) as? ImperialService else {
      fatalError("Google Registry is not configured") }
    return result
  }
}


public class GoogleService: ImperialService {
  static public func preflightURL() throws -> URL {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "accounts.google.com"
    urlComponents.path = "/o/oauth2/auth"
    
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
    redirectURI: String
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
    redirectURI: redirectURI,
    callback: callback)
  }
}
