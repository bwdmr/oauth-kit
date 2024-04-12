import Combine
import Foundation



public protocol GoogleToken: OAuthToken {
  var endpoint: URL { get set }
  
  var accessToken: AccessTokenClaim? { get set }
  
  var expiresIn: ExpiresInClaim? { get set }
  
  var refreshToken: RefreshTokenClaim? { get set }
  
  var scope: ScopeClaim { get set }
  
  var tokenType: TokenTypeClaim? { get set }
}



extension GoogleToken {
  public func verify() async throws {
    try self.expiresIn?.verifyNotExpired()
  }
  
  @discardableResult
  public func mergeable<Token>(_ other: inout Token)
  async throws -> Token where Token: OAuthToken {
    guard
      let accessToken = self.accessToken,
      let expiresIn = self.expiresIn,
      let refreshToken = self.refreshToken,
      let tokenType = self.tokenType
    else { throw OAuthError.missingRequirement(
      failedToken: other, reason: "insufficient information for authentication")}
    
    other.accessToken = accessToken
    other.expiresIn = expiresIn
    other.refreshToken = refreshToken
    other.scope = other.scope
    other.tokenType = tokenType
    
    return other
  }
}



@dynamicMemberLookup
public actor GoogleService: OAuthServiceable {
  public var id: OAuthIdentifier = OAuthIdentifier(string: "google")

  public let authenticationEndpoint: String?
  public let tokenEndpoint: String?
  
  @Published public var token: [String : OAuthToken] = [:]
  public var head: (OAuthToken)?
  
  enum CodingKeys: String, CodingKey {
    case id = "oauth_identifier"
    case authenticationEndpoint = "authentication_endpoint"
    case tokenEndpoint = "token_endpoint"
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
    authenticationEndpoint: String,
    tokenEndpoint: String,
    accessType: AccessTypeClaim = "online",
    clientID: ClientIDClaim,
    clientSecret: ClientSecretClaim,
    redirectURI: RedirectURIClaim,
    scope: ScopeClaim,
    state: StateClaim? = nil,
    grantType: GrantTypeClaim = "token",
    enablegranularConsent: EnableGranularConsentClaim? = nil,
    includegrantedScopes: IncludeGrantedScopesClaim? = nil,
    loginHint: LoginHintClaim? = nil,
    prompt: PromptClaim? = nil,
    responseType: ResponseTypeClaim = "code"
  ) {
    self.authenticationEndpoint = authenticationEndpoint
    self.tokenEndpoint = tokenEndpoint
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
  
  
  public func authenticationURL() throws -> URL {
    guard
      let endpoint = self.authenticationEndpoint,
      let endpointURL = URL(string: endpoint)
    else { throw OAuthError.invalidURL("misconfigured endpoint: \(String(describing: self.authenticationEndpoint))") }
    
    var components = URLComponents()
    components.scheme = endpointURL.scheme
    components.host = endpointURL.host
    components.path = endpointURL.path
    components.queryItems = {
      var queryitemList = [
        URLQueryItem(name: ClientIDClaim.key.stringValue, value: clientID.value),
        URLQueryItem(name: RedirectURIClaim.key.stringValue, value: redirectURI.value),
        URLQueryItem(name: ResponseTypeClaim.key.stringValue, value: responseType.value),
        URLQueryItem(name: ScopeClaim.key.stringValue, value: scope.value.joined()),
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
  
  
  public func tokenURL(code: String) throws -> (URL, [UInt8]) {
    guard
      let endpoint = self.tokenEndpoint,
      let endpointURL = URL(string: endpoint)
    else { throw OAuthError.invalidURL("misconfigured endpoint: \(String(describing: self.tokenEndpoint))") }
    
    var components = URLComponents()
    components.scheme = endpointURL.scheme
    components.host = endpointURL.host
    components.path = endpointURL.path
    
    let items = {
      let queryitemList = [
        URLQueryItem(name: ClientIDClaim.key.stringValue, value: clientID.value),
        URLQueryItem(name: ClientSecretClaim.key.stringValue, value: clientSecret.value),
        URLQueryItem(name: CodeClaim.key.stringValue, value: code),
        URLQueryItem(name: GrantTypeClaim.key.stringValue, value: grantType?.value),
        URLQueryItem(name: RedirectURIClaim.key.stringValue, value: redirectURI.value)
      ]
      
      return queryitemList
    }()
    
    guard let url = components.url else { throw OAuthError.invalidURL("misconfigured url.") }
    let data = try queryitemBuffer(items)
    
    return (url, data)
  }
}
