import Foundation




public struct GoogleService: OAuthServiceable {
  
  public var oauthIdentifier: OAuthIdentifier? = OAuthIdentifier(string: "google")
  
  public let authorizationEndpoint: String?
  
  public let accessEndpoint: String?
  
  enum CodingKeys: String, CodingKey {
    case oauthIdentifier = "oauth_identifier"
    case authorizationEndpoint = "authorization_endpoint"
    case accessEndpoint = "access_endpoint"
    case accessType = "access_type"
    case clientID = "client_id"
    case clientSecret = "client_secret"
    case enablegranularConsent = "enable_granular_consent"
    case grantType = "grant_type"
    case includegrantedScopes = "include_granted_scopes"
    case loginHint = "login_hint"
    case prompt = "prompt"
    case redirectURI = "redirect_uri"
    case responseType = "response_type"
    case scope = "scope"
    case state = "state"
  }
  
  public let accessType: AccessTypeClaim
  
  public let clientID: ClientIDClaim
  
  public let clientSecret: ClientSecretClaim
  
  public let enablegranularConsent: EnableGranularConsentClaim?
  
  public let grantType: GrantTypeClaim?
  
  public let includegrantedScopes: IncludeGrantedScopesClaim?
  
  public let loginHint: LoginHintClaim?
  
  public let prompt: PromptClaim?
  
  public let redirectURI: RedirectURIClaim
  
  public let responseType: ResponseTypeClaim
  
  public let scope: ScopeClaim
  
  public let state: StateClaim?
  
  public init(
    accessEndpoint: String,
    authorizationEndpoint: String,
    accessType: AccessTypeClaim = "online",
    clientID: ClientIDClaim,
    clientSecret: ClientSecretClaim,
    redirectURI: RedirectURIClaim,
    scope: ScopeClaim,
    state: StateClaim? = nil,
    grantType: GrantTypeClaim = "authorization_code",
    enablegranularConsent: EnableGranularConsentClaim? = nil,
    includegrantedScopes: IncludeGrantedScopesClaim? = nil,
    loginHint: LoginHintClaim? = nil,
    prompt: PromptClaim? = nil,
    responseType: ResponseTypeClaim = "code"
  ) {
    self.accessEndpoint = accessEndpoint
    self.authorizationEndpoint = authorizationEndpoint
    self.accessType = accessType
    self.clientID = clientID
    self.clientSecret = clientSecret
    self.enablegranularConsent = enablegranularConsent
    self.grantType = grantType
    self.includegrantedScopes = includegrantedScopes
    self.loginHint = loginHint
    self.prompt = prompt
    self.redirectURI = redirectURI
    self.responseType = responseType
    self.scope = scope
    self.state = state
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.oauthIdentifier = try container.decodeIfPresent(OAuthIdentifier.self, forKey: .oauthIdentifier)
    self.accessEndpoint = try container.decodeIfPresent(String.self, forKey: .accessEndpoint)
    self.authorizationEndpoint = try container.decodeIfPresent(String.self, forKey: .authorizationEndpoint)
    self.accessType = try container.decode(AccessTypeClaim.self, forKey: .accessType)
    self.clientID = try container.decode(ClientIDClaim.self, forKey: .clientID)
    self.clientSecret = try container.decode(ClientSecretClaim.self, forKey: .clientSecret)
    self.enablegranularConsent = try container.decodeIfPresent(EnableGranularConsentClaim.self, forKey: .enablegranularConsent)
    self.grantType = try container.decodeIfPresent(GrantTypeClaim.self, forKey: .grantType)
    self.includegrantedScopes = try container.decodeIfPresent(IncludeGrantedScopesClaim.self, forKey: .includegrantedScopes)
    self.loginHint = try container.decodeIfPresent(LoginHintClaim.self, forKey: .loginHint)
    self.prompt = try container.decodeIfPresent(PromptClaim.self, forKey: .prompt)
    self.redirectURI = try container.decode(RedirectURIClaim.self, forKey: .redirectURI)
    self.responseType = try container.decode(ResponseTypeClaim.self, forKey: .responseType)
    self.scope = try container.decode(ScopeClaim.self, forKey: .scope)
    self.state = try container.decodeIfPresent(StateClaim.self, forKey: .state)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(oauthIdentifier, forKey: .oauthIdentifier)
    try container.encodeIfPresent(accessEndpoint, forKey: .accessEndpoint)
    try container.encodeIfPresent(authorizationEndpoint, forKey: .authorizationEndpoint)
    try container.encode(accessType, forKey: .accessType)
    try container.encode(clientID, forKey: .clientID)
    try container.encode(clientSecret, forKey: .clientSecret)
    try container.encodeIfPresent(enablegranularConsent, forKey: .enablegranularConsent)
    try container.encodeIfPresent(grantType, forKey: .grantType)
    try container.encodeIfPresent(includegrantedScopes, forKey: .includegrantedScopes)
    try container.encodeIfPresent(loginHint, forKey: .loginHint)
    try container.encodeIfPresent(prompt, forKey: .prompt)
    try container.encode(redirectURI, forKey: .redirectURI)
    try container.encode(responseType, forKey: .responseType)
    try container.encode(scope, forKey: .scope)
    try container.encodeIfPresent(state, forKey: .state)
  }
  
  public func accessURL(code: String) throws -> URL {
    guard
      let endpoint = self.accessEndpoint,
      let endpointURL = URL(string: endpoint)
    else { throw OAuthError.invalidURL("misconfigured endpoint: \(self.accessEndpoint)") }
    
    var components = URLComponents()
    components.scheme = endpointURL.scheme
    components.host = endpointURL.host
    components.path = endpointURL.path
    components.queryItems = {
      var queryitemList = [
        URLQueryItem(name: ClientIDClaim.key.stringValue, value: clientID.value),
        URLQueryItem(name: ClientSecretClaim.key.stringValue, value: clientSecret.value),
        URLQueryItem(name: "code", value: code),
        URLQueryItem(name: GrantTypeClaim.key.stringValue, value: grantType?.value),
        URLQueryItem(name: RedirectURIClaim.key.stringValue, value: redirectURI.value)
      ]
      
      return queryitemList
    }()
    
    guard let url = components.url else { throw OAuthError.invalidURL("misconfigured url.") }
    return url
  }
  
  
  
  public func authorizationURL() throws -> URL {
    guard
      let endpoint = self.authorizationEndpoint,
      let endpointURL = URL(string: endpoint)
    else { throw OAuthError.invalidURL("misconfigured endpoint: \(self.authorizationEndpoint)") }
    
    var components = URLComponents()
    components.scheme = endpointURL.scheme
    components.host = endpointURL.host
    components.path = endpointURL.path
    components.queryItems = {
      var queryitemList = [
        URLQueryItem(name: ClientIDClaim.key.stringValue, value: clientID.value),
        URLQueryItem(name: RedirectURIClaim.key.stringValue, value: redirectURI.value),
        URLQueryItem(name: ResponseTypeClaim.key.stringValue, value: responseType.value),
        URLQueryItem(name: ScopeClaim.key.stringValue, value: scope.value),
        URLQueryItem(name: AccessTypeClaim.key.stringValue, value: accessType.value)
      ]
      
      if let state = self.state {
        let stateItem = URLQueryItem(name: StateClaim.key.stringValue, value: state.value)
        queryitemList.append(stateItem) }
      
      if let includegrantedScopes = self.includegrantedScopes {
        let includegrantedScopesItem = URLQueryItem(
          name: IncludeGrantedScopesClaim.key.stringValue,
          value:  includegrantedScopes.value.description)
        queryitemList.append(includegrantedScopesItem) }
      
      if let enablegranularConsent = self.enablegranularConsent {
        let enablegranularConsent = URLQueryItem(
          name: EnableGranularConsentClaim.key.stringValue,
          value: enablegranularConsent.value.description)
        queryitemList.append(enablegranularConsent) }
      
      if let loginHint = self.loginHint {
        let loginHintItem = URLQueryItem(
          name: LoginHintClaim.key.stringValue,
          value: loginHint.value)
        queryitemList.append(loginHintItem) }
      
      if let prompt = self.prompt {
        let promptItem = URLQueryItem(name: PromptClaim.key.stringValue, value: prompt.value)
        queryitemList.append(promptItem) }
      
      return queryitemList
    }()
    
    guard let url = components.url else { throw OAuthError.invalidURL("misconfigured url.") }
    return url
  }
}

  
