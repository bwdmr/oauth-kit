import Foundation


public struct ImperialCodingKey: CodingKey, Hashable, Equatable, ExpressibleByStringLiteral {
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


public protocol ImperialClaim: Codable, Sendable {
  associatedtype Value: Codable
  
  static var key: ImperialCodingKey { get }
  
  var value: Value { get set }
  init(value: Value)
}

public extension ImperialClaim where Value == String, Self: ExpressibleByStringLiteral {
  init(stringLiteral string: String) {
    self.init(value: string)
  }
}


public extension ImperialClaim {
  init(from decoder: Decoder) throws {
    let single = try decoder.singleValueContainer()
    try self.init(value: single.decode(Value.self))
  }
  
  func encode(to encoder: Encoder) throws {
    var single = encoder.singleValueContainer()
    try single.encode(value)
  }
}


public protocol ImperialUnixEpochClaim: ImperialClaim where Value == Date {}
public extension ImperialUnixEpochClaim {
    /// See `Decodable`.
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        try self.init(value: container.decode(Date.self))
    }

    /// See `Encodable`.
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }
}



public protocol ImperialBooleanClaim: ImperialClaim where Value == Bool, Self: ExpressibleByBooleanLiteral {}
public extension ImperialBooleanClaim {
  
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
        throw ImperialError.invalidBool(str)
      }
      
      self.init(value: bool)
    }
  }
}
