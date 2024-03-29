/// - See Also:
/// [Access Flow](https://developers.google.com/identity/protocols/oauth2/javascript-implicit-flow#oauth-2.0-endpoints)
/// [Authorization Flow](https://developers.google.com/identity/protocols/oauth2/web-server#httprest_1)
import Vapor


extension OAuthID {
  public static let google = OAuthID("google")
}


extension OAuthFactory {
  public var google: OAuthService {
    guard let result = make(.google) as? (any OAuthService) else {
      fatalError("Google Registry is not configured") }
    return result
  }
}

public struct GoogleService: OAuthService {
  public var req: Vapor.Request
  public var grantor: any Grantor
  public var grants: Dictionary<String, any OAuthGrantable> = [:]
  
  public init(req: Vapor.Request, grantor: any Grantor, grants: [any OAuthGrantable]) {
    self.req = req
    self.grantor = grantor
    
    for grant in grants {
      let name = grant.name
      self.grants[name] = grant
    }
  }
}

