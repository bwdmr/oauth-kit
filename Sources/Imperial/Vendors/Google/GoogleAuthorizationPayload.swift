import Vapor


public struct GoogleAuthorizationPayload: ImperialToken {
  public enum CodingKeys: String, CodingKey {
    case clientID
    case redirectURI
    case responseType
    case scope
    //    case accessType = "access_type"
    //    case state = "state"
    //    case includegrantedScopes = "include_granted_scopes"
    //    case enablegranularConsent = "enable_granular_consent"
    //    case loginHint = "login_hint"
    //    case prompt = "prompt"
    
    public init?(stringValue: String) {
      switch stringValue {
      case ClientIDClaim.key.stringValue: self = .clientID
      case RedirectURIClaim.key.stringValue: self = .redirectURI
      case ResponseTypeClaim.key.stringValue: self = .responseType
      case ScopeClaim.key.stringValue: self = .scope
      default: return nil
      }
    }
  }
 
  public let clientID: ClientIDClaim
  
  public let redirectURI: RedirectURIClaim
  
  public let responseType: ResponseTypeClaim
  
  public let scope: ScopeClaim
  
  public init(
    clientID: ClientIDClaim,
    redirectURI: RedirectURIClaim,
    responseType: ResponseTypeClaim,
    scope: ScopeClaim
  ) {
    self.clientID = clientID
    self.redirectURI = redirectURI
    self.responseType = responseType
    self.scope = scope
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.clientID, forKey: .clientID)
    try container.encode(self.redirectURI, forKey: .redirectURI)
    try container.encode(self.responseType, forKey: .responseType)
    try container.encode(self.scope, forKey: .scope)
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.clientID = try container.decode(ClientIDClaim.self, forKey: .clientID)
    self.redirectURI = try container.decode(RedirectURIClaim.self, forKey: .redirectURI)
    self.responseType = try container.decode(ResponseTypeClaim.self, forKey: .responseType)
    self.scope = try container.decode(ScopeClaim.self, forKey: .scope)
  }
}
