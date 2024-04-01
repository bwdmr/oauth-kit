import Foundation

public protocol OAuthJSONDecoder: Sendable {
    func decode<T: Decodable>(_: T.Type, from string: Data) throws -> T
}

public protocol OAuthJSONEncoder: Sendable {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

extension JSONDecoder: OAuthJSONDecoder {}

extension JSONEncoder: OAuthJSONEncoder {}


public extension OAuthJSONEncoder where Self == JSONEncoder {
  static var defaultForOAuth: JSONEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .secondsSince1970
    return encoder
  }
}


public extension OAuthJSONDecoder where Self == JSONDecoder {
  static var defaultForOAuth: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    return decoder
  }
}

