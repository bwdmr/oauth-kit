import Vapor



public protocol CacheGrant: Grantor {
  @Sendable func approve(req: Request, body: ImperialToken) async throws -> Void
  @Sendable func revoke(req: Request, body: ImperialToken) async throws -> Void
}


extension CacheGrant {
  @Sendable public func approve(req: Request, body: ImperialToken) async throws -> Void {
    req.approve(body)
  }
  
  @Sendable public func revoke(req: Request, body: ImperialToken) async throws -> Void {
    req.revoke(type(of: body))
  }
}


public struct CacheGrantable<
  Authorize: AuthorizationGrant,
  Refresh: RefreshGrant,
  Revoke: RevokeGrant
>: CacheGrant {
  public var grants: [String: Grantable]
  
  init( 
    authorizeURL: URL,
    refreshURL: URL,
    revokeURL: URL
  ) async throws {
    
    guard
      let authorizeScheme = authorizeURL.scheme,
      let authorizeHost = authorizeURL.host
    else { throw Abort(.internalServerError) }
    
    let authorizePath = authorizeURL.path
    let authorizeGrant = Authorize(
      scheme: authorizeScheme,
      host: authorizeHost,
      path: authorizePath,
      handler: {@Sendable (req: Request,body: ImperialToken) async throws -> Void in
        try await approve(req: req, body: body) })
    
    
    guard
      let refreshScheme = refreshURL.scheme,
      let refreshHost = refreshURL.host
    else { throw Abort(.internalServerError) }
    
    let refreshPath = refreshURL.path
    let refreshGrant = Refresh(
      scheme: refreshScheme,
      host: refreshHost,
      path: refreshPath,
      handler: {@Sendable (req: Request,body: ImperialToken) async throws -> Void in
        try await approve(req: req, body: body) })
        
    
    guard
      let revokeScheme = revokeURL.scheme,
      let revokeHost = revokeURL.host
    else { throw Abort(.internalServerError) }
    
    let revokePath = revokeURL.path
    let revokeGrant = Revoke(
      scheme: revokeScheme,
      host: revokeHost,
      path: revokePath,
      handler: {@Sendable (req: Request,body: ImperialToken) async throws -> Void in
        try await revoke(req: req, body: body) })
    
    
    self.grants = [
      "authorize": authorizeGrant,
      "refresh": refreshGrant,
      "revoke": revokeGrant
    ]
  }
}
