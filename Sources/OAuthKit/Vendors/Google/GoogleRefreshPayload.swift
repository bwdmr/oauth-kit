import Vapor

public struct GoogleRefreshPayload: OAuthToken {
  
  public enum CodingKeys: String, CodingKey {
    case clientID
    case clientSecret
    case grantType
    case refreshToken
    
    public init?(stringValue: String) {
      switch stringValue {
      case ClientIDClaim.key.stringValue: self = .clientID
      case ClientSecretClaim.key.stringValue: self = .clientSecret
      case GrantTypeClaim.key.stringValue: self = .grantType
      case RefreshTokenClaim.key.stringValue: self = .refreshToken
      default: return nil
      }
    }
  }
  
  public var clientID: ClientIDClaim
  
  public var clientSecret: ClientSecretClaim
  
  public var grantType: GrantTypeClaim
  
  public var refreshToken: RefreshTokenClaim
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.clientID, forKey: .clientID)
    try container.encode(self.clientSecret, forKey: .clientSecret)
    try container.encode(self.grantType, forKey: .grantType)
    try container.encode(self.refreshToken, forKey: .refreshToken)
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.clientID = try container.decode(ClientIDClaim.self, forKey: .clientID)
    self.clientSecret = try container.decode(ClientSecretClaim.self, forKey: .clientSecret)
    self.grantType = try container.decode(GrantTypeClaim.self, forKey: .grantType)
    self.refreshToken = try container.decode(RefreshTokenClaim.self, forKey: .refreshToken)
  }
}
