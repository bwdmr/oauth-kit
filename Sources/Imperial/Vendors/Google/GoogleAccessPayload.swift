import Vapor

public struct GoogleAccessPayload: ImperialToken {
  
  public enum CodingKeys: String, CodingKey {
    case clientID = "client_id"
    case clientSecret = "client_secret"
    case code = "code" 
    case grantType = "grant_type"
    case redirectURI = "redirect_uri"
  }
  
  public let clientID: ClientIDClaim
  
  public let clientSecret: ClientSecretClaim
  
  public let code: CodeClaim
  
  public let grantType: GrantTypeClaim
  
  public let redirectURI: RedirectURIClaim
  
  public init(
    clientID: ClientIDClaim,
    clientSecret: ClientSecretClaim,
    code: CodeClaim,
    grantType: GrantTypeClaim,
    redirectURI: RedirectURIClaim
  ) {
    self.clientID = clientID
    self.clientSecret = clientSecret
    self.code = code
    self.grantType = grantType
    self.redirectURI = redirectURI
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.clientID, forKey: .clientID)
    try container.encode(self.clientSecret, forKey: .clientSecret)
    try container.encode(self.code, forKey: .code)
    try container.encode(self.grantType, forKey: .grantType)
    try container.encode(self.redirectURI, forKey: .redirectURI)
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.clientID = try container.decode(ClientIDClaim.self, forKey: .clientID)
    self.clientSecret = try container.decode(ClientSecretClaim.self, forKey: .clientSecret)
    self.code = try container.decode(CodeClaim.self, forKey: .code)
    self.grantType = try container.decode(GrantTypeClaim.self, forKey: .grantType)
    self.redirectURI = try container.decode(RedirectURIClaim.self, forKey: .redirectURI)
  }
}
