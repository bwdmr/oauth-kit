import Foundation


struct OAuthService: Sendable {
  public var jsonDecoder: OAuthJSONDecoder = .defaultForOAuth
  public var configuration: OAuthConfiguration
  
  init(_ configuration: OAuthConfiguration) {
    self.configuration = configuration
  }
  
  
  func verify<Token>(_ token: some DataProtocol) async throws -> Token
    where Token: OAuthToken {
    
    var _token: Token
    do {
      let encodedToken = token.copyBytes()
      _token = try jsonDecoder.decode(
        Token.self,
        from: .init(encodedToken.base64URLDecodedBytes())
      )
    } catch {
      throw OAuthError.invalidToken(
        "Couldn't decode OAuth with error: \(String(describing: error))")
    }
    
    try await _token.verify()
    return _token
  }
}
