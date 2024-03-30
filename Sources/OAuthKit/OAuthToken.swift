public protocol OAuthToken: Codable, Sendable {
  func verify() async throws
}
