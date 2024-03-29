/// This approach is suitable for client applications that don't need long-lived access to resources
/// or when the resource server doesn't support or want to issue refresh tokens.
/// ex.: Federated Login or access to regulated and/or compliance requirement-related data.
/// See Also:
/// - [Authorization Flow](https://developers.google.com/identity/protocols/oauth2/web-server#httprest_3)
import Vapor



struct AuthorizationGrant<
  T: ImperialToken,
  U: ImperialToken
>: ImperialGrantable {
  
  var name: String
  var scheme: String
  var host: String
  var path: String
  var handler: (@Sendable (Vapor.Request, U?) async throws -> Void)?
  
  
  public func generateURI(payload: T) throws -> URI {
    guard
      let clientID = payload.clientID,
      let redirectURI = payload.redirectURI,
      let responseType = payload.responseType,
      let scope = payload.scope
    else { throw Abort(.internalServerError) }
    
    var components = URLComponents()
    components.scheme = self.scheme
    components.host = self.host
    components.path = self.path
    components.queryItems = {
      var queryitemList = [
        URLQueryItem(name: ClientIDClaim.key.stringValue, value: clientID.value),
        URLQueryItem(name: RedirectURIClaim.key.stringValue, value: redirectURI.value),
        URLQueryItem(name: ResponseTypeClaim.key.stringValue, value: responseType.value),
        URLQueryItem(name: ScopeClaim.key.stringValue, value: scope.value)
      ]
      
      if let accessType = payload.accessType {
        let accessTypeItem = URLQueryItem(name: AccessTypeClaim.key.stringValue, value: accessType.value)
        queryitemList.append(accessTypeItem) }
      
      if let state = payload.state {
        let stateItem = URLQueryItem(name: StateClaim.key.stringValue, value: state.value)
        queryitemList.append(stateItem) }
      
      if let includegrantedScopes = payload.includegrantedScopes {
        let includegrantedScopesItem = URLQueryItem(
          name: IncludeGrantedScopesClaim.key.stringValue,
          value:  includegrantedScopes.value.description)
        queryitemList.append(includegrantedScopesItem) }
      
      if let enablegranularConsent = payload.enablegranularConsent {
        let enablegranularConsent = URLQueryItem(
          name: EnableGranularConsentClaim.key.stringValue,
          value: enablegranularConsent.value.description)
        queryitemList.append(enablegranularConsent) }
      
      if let loginHint = payload.loginHint {
        let loginHintItem = URLQueryItem(
          name: LoginHintClaim.key.stringValue,
          value: loginHint.value)
        queryitemList.append(loginHintItem) }
      
      if let prompt = payload.prompt {
        let promptItem = URLQueryItem(name: PromptClaim.key.stringValue, value: prompt.value)
        queryitemList.append(promptItem) }
      
      return queryitemList
    }()
    
    guard let url = components.url else { throw Abort(.notFound) }
    let urlString = url.absoluteString
    let uri = URI(string: urlString)
    return uri
  }
  
  
  public func flow(req: Request, data: Data?) async throws {
    guard let data = data else { throw Abort(.notFound) }
    let tokenBody = try JSONDecoder().decode(U.self, from: data)
    
    guard let handler = handler else { throw Abort(.notFound) }
    try await handler(req, tokenBody)
  }
}
