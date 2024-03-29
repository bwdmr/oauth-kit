import Vapor

public struct GoogleRefreshToken: OAuthToken {
  
  public enum CodingKeys: String, CodingKey {
    case accessToken
    case expiresIn
    case scope
    case tokenType
    
    public init?(stringValue: String) {
      switch stringValue {
      case AccessTokenClaim.key.stringValue: self = .accessToken
      case ExpiresInClaim.key.stringValue: self = .expiresIn
      case ScopeClaim.key.stringValue: self = .scope
      case TokenTypeClaim.key.stringValue: self = .tokenType
        
      default: return nil
      }
    }
  }
  
  public let accessToken: AccessTokenClaim
  
  public let expiresIn: ExpiresInClaim
  
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
    self.scope = scope
    self.tokenType = tokenType
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.accessToken, forKey: .accessToken)
    try container.encode(self.expiresIn, forKey: .expiresIn)
    try container.encode(self.scope, forKey: .scope)
    try container.encode(self.tokenType, forKey: .tokenType)
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.accessToken = try container.decode(AccessTokenClaim.self, forKey: .accessToken)
    self.expiresIn = try container.decode(ExpiresInClaim.self, forKey: .expiresIn)
    self.scope = try container.decode(ScopeClaim.self, forKey: .scope)
    self.tokenType = try container.decode(TokenTypeClaim.self, forKey: .tokenType)
  }
}
