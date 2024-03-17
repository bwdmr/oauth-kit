

extension ImperialID {
  static let google = ImperialID("google")
}

extension ImperialFactory {
  var google:  {
    guard let result = make(.google) as? ImperialRegistry else {
      fatalError("Google Registry is not configured")
    }
    return result
  }
}

public struct GoogleService: ImperialService {
  
  public var req: Request
  public var clientID: String
  public var clientSecret: String
  public var redirectURI: String
  public var authURL: URL
  public var flowURL: URL
  public var token: GenericImperialToken
  
  public init(
    req: Request,
    authURL: URL,
    flowURL: URL,
    clientID: String,
    clientSecret: String,
    redirectURI: String,
    callback: @escaping (Request, ImperialBody) async throws -> Void
  ) throws {
    
    let authScheme = try authURL.scheme.value(or: Abort(.notFound))
    let authHost = try authURL.host.value(or: Abort(.notFound))
    let authPath = authURL.path
    
    let token = ImperialToken(
      scheme: authScheme,
      host: authHost,
      path: authPath,
      clientID: clientID,
      clientSecret: clientSecret,
      redirectURI: redirectURI,
      callback: callback
    )
    
    self.req = req
    self.token = token
  }
}

let googleService = GoogleService(
  req: <#T##Request#>, authURL: <#T##URL#>, flowURL: <#T##URL#>, clientID: <#T##String#>, clientSecret: <#T##String#>, redirectURI: <#T##String#>, callback: <#T##(Request, ImperialBody) -> Void#>)
