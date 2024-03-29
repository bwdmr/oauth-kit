import Vapor

public struct GoogleAccessToken: ImperialToken {
  
  public enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case expiresIn = "expires_in"
    case refreshToken = "refresh_token"
    case scope = "scope"
    case tokenType = "token_type"
  }
  
  public let accessToken: AccessTokenClaim
  
  public let expiresIn: ExpiresInClaim
  
  public let refreshToken: RefreshTokenClaim
  
  public let scope: ScopeClaim
  
  public let tokenType: TokenTypeClaim
  
  public init(
    accessToken: AccessTokenClaim,
    expiresIn: ExpiresInClaim,
    refreshToken: RefreshTokenClaim,
    scope: ScopeClaim,
    tokenType: TokenTypeClaim
  ) {
    self.accessToken = accessToken
    self.expiresIn = expiresIn
    self.refreshToken = refreshToken
    self.scope = scope
    self.tokenType = tokenType
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.accessToken, forKey: .accessToken)
    try container.encode(self.expiresIn, forKey: .expiresIn)
    try container.encode(self.refreshToken, forKey: .refreshToken)
    try container.encode(self.scope, forKey: .scope)
    try container.encode(self.tokenType, forKey: .tokenType)
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.accessToken = try container.decode(AccessTokenClaim.self, forKey: .accessToken)
    self.expiresIn = try container.decode(ExpiresInClaim.self, forKey: .expiresIn)
    self.refreshToken = try container.decode(RefreshTokenClaim.self, forKey: .refreshToken)
    self.scope = try container.decode(ScopeClaim.self, forKey: .scope)
    self.tokenType = try container.decode(TokenTypeClaim.self, forKey: .tokenType)
  }
}

