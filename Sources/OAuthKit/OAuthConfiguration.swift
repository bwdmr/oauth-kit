import Foundation


public protocol OAuthConfiguration: Codable, Sendable {
  func configureauthorizationURL() throws -> URL
  func configureaccessURL(code: String) throws -> URL
}
