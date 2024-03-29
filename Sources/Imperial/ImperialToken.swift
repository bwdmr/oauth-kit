import Vapor



public protocol ImperialToken: ImperialTokenable, Content, Codable, Sendable {
  associatedtype CodingKeys: CodingKey
  
  func encode(to encoder: Encoder) throws
  init(from decoder: Decoder) throws
}


public protocol ImperialTokenable {
  var accessToken: AccessTokenClaim? { get }
  var clientID: ClientIDClaim? { get }
  var clientSecret: ClientSecretClaim? { get }
  var code: CodeClaim? { get }
  var expiresIn: ExpiresInClaim? { get }
  var grantType: GrantTypeClaim? { get }
  var redirectURI: RedirectURIClaim? { get }
  var refreshToken: RefreshTokenClaim? { get }
  var responseType: ResponseTypeClaim? { get }
  var scope: ScopeClaim? { get }
  var token: TokenClaim? { get }
  var tokenType: TokenTypeClaim? { get }
}

extension ImperialTokenable {
  public var accessToken: AccessTokenClaim? { nil }
  public var clientID: ClientIDClaim? { nil }
  public var clientSecret: ClientSecretClaim? { nil }
  public var code: CodeClaim? { nil }
  public var expiresIn: ExpiresInClaim? { nil }
  public var grantType: GrantTypeClaim? { nil }
  public var redirectURI: RedirectURIClaim? { nil }
  public var refreshToken: RefreshTokenClaim? { nil }
  public var responseType: ResponseTypeClaim? { nil }
  public var scope: ScopeClaim? { nil }
  public var token: TokenClaim? { nil }
  public var tokenType: TokenTypeClaim? { nil }
}


