import Vapor

public struct GoogleAuthorizationToken: OAuthToken {
  public enum CodingKeys: String, CodingKey {
    case code
    
    public init?(stringValue: String) {
      switch stringValue {
      case CodeClaim.key.stringValue: self = .code
      default: return nil
      }
    }
  }
  
  public var code: CodeClaim
  
  public init(
    code: CodeClaim
  ) {
    self.code = code
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.code, forKey: .code)
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.code = try container.decode(CodeClaim.self, forKey: .code)
  }
}
