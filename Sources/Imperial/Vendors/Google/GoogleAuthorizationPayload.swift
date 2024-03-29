import Vapor


public struct GoogleAuthorizationPayload: ImperialToken {
  public enum CodingKeys: String, CodingKey {
    case clientID
    case redirectURI
    case responseType
    case scope
    case accessType
    case state
    case includegrantedScopes
    case enablegranularConsent
    case loginHint
    case prompt
    
    public init?(stringValue: String) {
      switch stringValue {
      case ClientIDClaim.key.stringValue: self = .clientID
      case RedirectURIClaim.key.stringValue: self = .redirectURI
      case ResponseTypeClaim.key.stringValue: self = .responseType
      case ScopeClaim.key.stringValue: self = .scope
      case AccessTypeClaim.key.stringValue: self = .accessType
      case StateClaim.key.stringValue: self = .state
      case IncludeGrantedScopesClaim.key.stringValue: self = .includegrantedScopes
      case EnableGranularConsentClaim.key.stringValue: self = .enablegranularConsent
      case LoginHintClaim.key.stringValue: self = .loginHint
      case PromptClaim.key.stringValue: self = .prompt
      default: return nil
      }
    }
  }
 
  public let clientID: ClientIDClaim
  
  public let redirectURI: RedirectURIClaim
  
  public let responseType: ResponseTypeClaim
  
  public let scope: ScopeClaim
  
  public let accessType: AccessTypeClaim?
  
  public let state: StateClaim?
  
  public let includegrantedScopes: IncludeGrantedScopesClaim?
  
  public let enablegranularConsent: EnableGranularConsentClaim?
  
  public let loginHint: LoginHintClaim?
  
  public let prompt: PromptClaim?
  
  public init(
    clientID: ClientIDClaim,
    redirectURI: RedirectURIClaim,
    responseType: ResponseTypeClaim,
    scope: ScopeClaim,
    accessType: AccessTypeClaim? = nil,
    state: StateClaim? = nil,
    includegrantedScopes: IncludeGrantedScopesClaim? = nil,
    enablegranularConsent: EnableGranularConsentClaim? = nil,
    loginHint: LoginHintClaim? = nil,
    prompt: PromptClaim? = nil
  ) {
    self.clientID = clientID
    self.redirectURI = redirectURI
    self.responseType = responseType
    self.scope = scope
    self.accessType = accessType
    self.state = state
    self.includegrantedScopes = includegrantedScopes
    self.enablegranularConsent = enablegranularConsent
    self.loginHint = loginHint
    self.prompt = prompt
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.clientID, forKey: .clientID)
    try container.encode(self.redirectURI, forKey: .redirectURI)
    try container.encode(self.responseType, forKey: .responseType)
    try container.encode(self.scope, forKey: .scope)
    
    try container.encodeIfPresent(self.accessType, forKey: .accessType)
    try container.encodeIfPresent(self.state, forKey: .state)
    try container.encodeIfPresent(self.includegrantedScopes, forKey: .includegrantedScopes)
    try container.encodeIfPresent(self.enablegranularConsent, forKey: .enablegranularConsent)
    try container.encodeIfPresent(self.loginHint, forKey: .loginHint)
    try container.encodeIfPresent(self.prompt, forKey: .prompt)
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.clientID = try container.decode(ClientIDClaim.self, forKey: .clientID)
    self.redirectURI = try container.decode(RedirectURIClaim.self, forKey: .redirectURI)
    self.responseType = try container.decode(ResponseTypeClaim.self, forKey: .responseType)
    self.scope = try container.decode(ScopeClaim.self, forKey: .scope)
    
    self.accessType = try container.decodeIfPresent(AccessTypeClaim.self, forKey: .accessType)
    self.state = try container.decodeIfPresent(StateClaim.self, forKey: .state)
    self.includegrantedScopes = try container.decodeIfPresent(
      IncludeGrantedScopesClaim.self, forKey: .includegrantedScopes)
    self.enablegranularConsent = try container.decodeIfPresent(
      EnableGranularConsentClaim.self, forKey: .enablegranularConsent)
    self.loginHint = try container.decodeIfPresent(LoginHintClaim.self, forKey: .loginHint)
    self.prompt = try container.decodeIfPresent(PromptClaim.self, forKey: .prompt)
  }
}
