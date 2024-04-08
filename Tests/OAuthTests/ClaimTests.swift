import OAuthKit
import XCTest


final class ClaimTests: XCTestCase {
 
  
  ///
  func testAccessTokenClaim() throws {
    
    struct AccessTokenPayload: Codable {
      var access_token: AccessTokenClaim
    }
    
    let str = #"{"access_token": "1/fFAGRNJru1FTz70BzhT3Zg"}"#
    let data = str.data(using: .utf8)!
    let decoded = try! JSONDecoder().decode(AccessTokenPayload.self, from: data)
    XCTAssertEqual(decoded.access_token, "1/fFAGRNJru1FTz70BzhT3Zg")
  }
 
  
  ///
  func testAccessTypeClaim() throws {
    
    struct AccessTypePayload: Codable {
      var access_type: AccessTypeClaim
    }
    
    let str = #"{"access_type": "offline"}"#
    let data = str.data(using: .utf8)!
    let decoded = try! JSONDecoder().decode(AccessTypePayload.self, from: data)
    XCTAssertEqual(decoded.access_type, "offline")
  }
  
  
  ///
  func testClientIDClaim() throws {
    
    struct ClientIDPayload: Codable {
      var client_id: ClientIDClaim
    }
    
    let str = #"{"client_id": "123456789.apps.googleusercontent.com"}"#
    let data = str.data(using: .utf8)!
    let decoded = try! JSONDecoder().decode(ClientIDPayload.self, from: data)
    XCTAssertEqual(decoded.client_id, "123456789.apps.googleusercontent.com")
  }
  
 
  ///
  func testClientSecretClaim() throws {
    
    struct ClientSecretPayload: Codable {
      var client_secret: ClientSecretClaim
    }
    
    let str = #"{"client_secret": "abc123"}"#
    let data = str.data(using: .utf8)!
    let decoded = try! JSONDecoder().decode(ClientSecretPayload.self, from: data)
    XCTAssertEqual(decoded.client_secret, "abc123")
  }
  
 
  ///
  func testCodeClaim() throws {
    
    struct CodePayload: Codable {
      var code: CodeClaim
    }
    
    let str = #"{"code": "4/P7q7W91a-oMsCeLvIaQm6bTrgtp7"}"#
    let data = str.data(using: .utf8)!
    let decoded = try! JSONDecoder().decode(CodePayload.self, from: data)
    XCTAssertEqual(decoded.code, "4/P7q7W91a-oMsCeLvIaQm6bTrgtp7")
  }
  
  
  func testEnableGranularConsentClaim() throws {
    
    struct EnableGranularConsentPayload: Codable {
      var enable_granular_consent: EnableGranularConsentClaim
    }
    
    let str = #"{"enable_granular_consent": "true"}"#
    let data = str.data(using: .utf8)!
    let decoded = try! JSONDecoder().decode(EnableGranularConsentPayload.self, from: data)
    XCTAssertEqual(decoded.enable_granular_consent, true)
  }
  
 
  func testExpiresInClaim() throws {
    
    struct ExpiresInPayload: Codable {
      var expires_in: ExpiresInClaim
    }
    
    let str = #"{"expires_in": "3920"}"#
    let data = str.data(using: .utf8)!
    let decoded = try! JSONDecoder().decode(ExpiresInPayload.self, from: data)
    XCTAssertEqual(decoded.expires_in, 3920)
  }
  
  
  func testGrantTypeClaim() throws {
    
    struct GrantTypePayload: Codable {
      var grant_type: GrantTypeClaim
    }
    
    let str = #"{"grant_type": "refresh_token"}"#
    let data = str.data(using: .utf8)!
    let decoded = try! JSONDecoder().decode(GrantTypePayload.self, from: data)
    XCTAssertEqual(decoded.grant_type, "refresh_token")
  }
  
  
  func testIncludeGrantedScopesClaim() throws {
    
    struct IncludeGrantedScopesPayload: Codable {
      var include_granted_scopes: IncludeGrantedScopesClaim
    }
    
    let str = #"{"include_granted_scopes": "true"}"#
    let data = str.data(using: .utf8)!
    let decoded = try! JSONDecoder().decode(IncludeGrantedScopesPayload.self, from: data)
    XCTAssertEqual(decoded.include_granted_scopes, true)
  }
  
  
  func testLoginHintClaim() throws {
    
    struct LoginHintPayload: Codable {
      var login_hint: LoginHintClaim
    }
    
    let str = #"{"login_hint": "user@example.com"}"#
    let data = str.data(using: .utf8)!
    let decoded = try! JSONDecoder().decode(LoginHintPayload.self, from: data)
    XCTAssertEqual(decoded.login_hint, "user@example.com")
  }
  
  
  func testpromptClaim() throws {
    
    struct PromptPayload: Codable {
      var prompt: PromptClaim
    }
    
    let str = #"{"prompt": "consent"}"#
    let data = str.data(using: .utf8)!
    let decoded = try! JSONDecoder().decode(PromptPayload.self, from: data)
    XCTAssertEqual(decoded.prompt, "consent")
  }
  
  
  func testRedirectURIClaim() throws {
    
    struct RedirectURIPayload: Codable {
      var redirect_uri: RedirectURIClaim
    }
    
    let str = #"{"redirect_uri": "https://oauth2.example.com/code"}"#
    let data = str.data(using: .utf8)!
    let decoded = try! JSONDecoder().decode(RedirectURIPayload.self, from: data)
    XCTAssertEqual(decoded.redirect_uri, "https://oauth2.example.com/code")
  }
  
  
  func testRefreshTokenClaim() throws {
    
    struct RefreshTokenPayload: Codable {
      var refresh_token: RefreshTokenClaim
    }
    
    let str = #"{"refresh_token": "1//xEoDL4iW3cxlI7yDbSRFYNG01kVKM2C-259HOF2aQbI"}"#
    let data = str.data(using: .utf8)!
    let decoded = try! JSONDecoder().decode(RefreshTokenPayload.self, from: data)
    XCTAssertEqual(decoded.refresh_token, "1//xEoDL4iW3cxlI7yDbSRFYNG01kVKM2C-259HOF2aQbI")
  }
  
  
  func testResponseTypeClaim() throws {
    
    struct ResponseTypePayload: Codable {
      var response_type: ResponseTypeClaim
    }
    
    let str = #"{"response_type": "code"}"#
    let data = str.data(using: .utf8)!
    let decoded = try! JSONDecoder().decode(ResponseTypePayload.self, from: data)
    XCTAssertEqual(decoded.response_type, "code")
  }
  
  
  func testScopeClaim() throws {
    
    struct ScopePayload: Codable {
      var scope: ScopeClaim
    }
    
    let str = #"{"scope": "https://www.googleapis.com/auth/drive.metadata.readonly/"}"#
    let data = str.data(using: .utf8)!
    let decoded = try! JSONDecoder().decode(ScopePayload.self, from: data)
    XCTAssertTrue(decoded.scope.value.contains( "https://www.googleapis.com/auth/drive.metadata.readonly/"
    ))
  }
  
  
  func testStateClaim() throws {
    
    struct StatePayload: Codable {
      var state: StateClaim
    }
    
    let str = #"{"state": "state_parameter_passthrough_value"}"#
    let data = str.data(using: .utf8)!
    let decoded = try! JSONDecoder().decode(StatePayload.self, from: data)
    XCTAssertEqual(decoded.state, "state_parameter_passthrough_value")
  }
  
  
  func testTokenClaim() throws {
    
    struct TokenPayload: Codable {
      var token: TokenClaim
    }
    
    let str = #"{"token": "1//xEoDL4iW3cxlI7yDbSRFYNG01kVKM2C-259HOF2aQbI"}"#
    let data = str.data(using: .utf8)!
    let decoded = try! JSONDecoder().decode(TokenPayload.self, from: data)
    XCTAssertEqual(decoded.token, "1//xEoDL4iW3cxlI7yDbSRFYNG01kVKM2C-259HOF2aQbI")
  }
  
  
  func testTokenTypeClaim() throws {
    
    struct TokenTypePayload: Codable {
      var token_type: TokenTypeClaim
    }
    
    let str = #"{"token_type": "Bearer"}"#
    let data = str.data(using: .utf8)!
    let decoded = try! JSONDecoder().decode(TokenTypePayload.self, from: data)
    XCTAssertEqual(decoded.token_type, "Bearer")
  }
}


