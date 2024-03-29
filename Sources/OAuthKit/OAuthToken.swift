import Vapor



public protocol OAuthToken: OAuthTokenable, Content, Codable, Sendable {
  associatedtype CodingKeys: CodingKey
  
  func encode(to encoder: Encoder) throws
  init(from decoder: Decoder) throws
}


public protocol OAuthTokenable {
  var accessToken: AccessTokenClaim? { get }
  var accessType: AccessTypeClaim? { get }
  var clientID: ClientIDClaim? { get }
  var clientSecret: ClientSecretClaim? { get }
  var code: CodeClaim? { get }
  var enablegranularConsent: EnableGranularConsentClaim? { get }
  var expiresIn: ExpiresInClaim? { get }
  var grantType: GrantTypeClaim? { get }
  var includegrantedScopes: IncludeGrantedScopesClaim? { get }
  var loginHint: LoginHintClaim? { get }
  var prompt: PromptClaim? { get }
  var redirectURI: RedirectURIClaim? { get }
  var refreshToken: RefreshTokenClaim? { get }
  var responseType: ResponseTypeClaim? { get }
  var scope: ScopeClaim? { get }
  var state: StateClaim? { get }
  var token: TokenClaim? { get }
  var tokenType: TokenTypeClaim? { get }
}

extension OAuthTokenable {
  public var accessToken: AccessTokenClaim? { nil }
  public var accessType: AccessTypeClaim? { nil }
  public var clientID: ClientIDClaim? { nil }
  public var clientSecret: ClientSecretClaim? { nil }
  public var code: CodeClaim? { nil }
  public var enablegranularConsent: EnableGranularConsentClaim? { nil }
  public var expiresIn: ExpiresInClaim? { nil }
  public var grantType: GrantTypeClaim? { nil }
  public var includegrantedScopes: IncludeGrantedScopesClaim? { nil }
  public var loginHint: LoginHintClaim? { nil }
  public var prompt: PromptClaim? { nil }
  public var redirectURI: RedirectURIClaim? { nil }
  public var refreshToken: RefreshTokenClaim? { nil }
  public var responseType: ResponseTypeClaim? { nil }
  public var scope: ScopeClaim? { nil }
  public var state: StateClaim? { nil }
  public var token: TokenClaim? { nil }
  public var tokenType: TokenTypeClaim? { nil }
}


