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
  static public func authorizationURL() throws -> URL {
    guard let url = URL(string: "hellow world") else { throw Abort(.notFound) }
    return url
  }
  
  static public func refreshURL() throws -> URL {
    guard let url = URL(string: "hellow world") else { throw Abort(.notFound) }
    return url
  }
  
  convenience init?(
    req: Request,
    clientID: String,
    clientSecret: String,
    redirectURI: String
 ) throws {
   let authorizationURL = try GoogleService.authorizationURL()
   let refreshURL = try GoogleService.refreshURL()
   
   let callback = { @Sendable (req: Request, body: ImperialBody) async throws in
     print("function") }
    
   try self.init(
    req: req,
    authURL: authorizationURL,
    flowURL: refreshURL,
    clientID: clientID,
    clientSecret: clientSecret,
    redirectURI: redirectURI,
    callback: callback)
  }
}
