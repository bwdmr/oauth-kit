import Foundation


public struct OAuthCodingKey: CodingKey, Hashable, Equatable, ExpressibleByStringLiteral {
  public typealias StringLiteralType = String
  
  public var stringValue: String
  public var intValue: Int?
  
  public init(stringLiteral: String) {
    self.init(stringValue: stringLiteral)
  }
  
  public init(stringValue: String) {
    self.stringValue = stringValue
    self.intValue = Int(stringValue)
  }
  
  public init(intValue: Int) {
    self.stringValue = intValue.description
    self.intValue = intValue
  }
}



public protocol OAuthClaim: Codable, Sendable {
  associatedtype Value: Codable
  
  static var key: OAuthCodingKey { get }
  
  var value: Value { get set }
  init(value: Value)
}

public extension OAuthClaim where Value == String, Self: ExpressibleByStringLiteral {
  init(stringLiteral string: String) {
    self.init(value: string)
  }
}

public extension OAuthClaim {
  init(from decoder: Decoder) throws {
    let single = try decoder.singleValueContainer()
    try self.init(value: single.decode(Value.self))
  }
  
  func encode(to encoder: Encoder) throws {
    var single = encoder.singleValueContainer()
    try single.encode(value)
  }
}



public protocol OAuthIntegerClaim: OAuthClaim where Value == Int, Self: ExpressibleByIntegerLiteral {}
public extension OAuthIntegerClaim {
  
  init(value: Int) {
    self.init(value: value)
  }
  
  init(stringLiteral value: String) {
    let value = Int(value) ?? 0
    self.init(value: value)
  }
  
  init(integerLiteral value: Int) {
    self.init(value: value)
  }
  
  init(from decoder: Decoder) throws {
    let single = try decoder.singleValueContainer()
    
    do {
      try self.init(value: single.decode(Int.self))
    } catch {
      let str = try single.decode(String.self)
      guard let int = Int(str) else {
        throw OAuthError.invalidInt(str)
      }
      
      self.init(value: int)
    }
  }
}



public protocol OAuthBooleanClaim: OAuthClaim where Value == Bool, Self: ExpressibleByBooleanLiteral {}
public extension OAuthBooleanClaim {
  
  init(value: Bool) {
    self.init(value: value)
  }
  
  init(stringLiteral value: String) {
    let value = Bool(value) ?? false
    self.init(value: value)
  }
  
  init(booleanLiteral value: Bool) {
    self.init(value: value)
  }
  
  /// See `Decodable`.
  init(from decoder: Decoder) throws {
    let single = try decoder.singleValueContainer()
    
    do {
      try self.init(value: single.decode(Bool.self))
    } catch {
      let str = try single.decode(String.self)
      guard let bool = Bool(str) else {
        throw OAuthError.invalidBool(str)
      }
      
      self.init(value: bool)
    }
  }
}
