/// - See Also:
/// [Access Flow](https://developers.google.com/identity/protocols/oauth2/javascript-implicit-flow#oauth-2.0-endpoints)
/// [Authorization Flow](https://developers.google.com/identity/protocols/oauth2/web-server#httprest_1)
import Vapor


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
  public var grantor: any Grantor
  public var grants: Dictionary<String, any ImperialGrantable> = [:]
  
  public init(req: Vapor.Request, grantor: any Grantor, grants: [any ImperialGrantable]) {
    self.req = req
    self.grantor = grantor
    
    for grant in grants {
      let name = grant.name
      self.grants[name] = grant
    }
  }
}

