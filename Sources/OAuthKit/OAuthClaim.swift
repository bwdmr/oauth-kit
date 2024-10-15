import Foundation


public struct OAuthCodingKey: Sendable, CodingKey, Hashable, Equatable, ExpressibleByStringLiteral {
  public typealias StringLiteralType = String
  
  public let stringValue: String
  public let intValue: Int?
  
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



public protocol OAuthClaim: Sendable, Codable {
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
      try self.init(value: single.decode(Int.self)) }
    
    catch {
      let str = try single.decode(String.self)
      guard let int = Int(str) else {
        throw OAuthError.invalidInt(str) }
      
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
      try self.init(value: single.decode(Bool.self)) }
    
    catch {
      let str = try single.decode(String.self)
      guard let bool = Bool(str) else {
        throw OAuthError.invalidBool(str) }
      
      self.init(value: bool)
    }
  }
}


public protocol OAuthMultiValueClaim: OAuthClaim where Value: Collection, Value.Element: Codable {
    init(value: Value.Element)
}


public extension OAuthMultiValueClaim {
    /// Single-element initializer. Uses the `CollectionOfOneDecoder` to work
    /// around the lack of an initializer on the `Collection` protocol. Not
    /// spectacularly efficient, but it works.
    init(value: Value.Element) {
        self.init(value: try! CollectionOfOneDecoder<Value>.decode(value))
    }

    /// Because multi-value claims can take either singular or plural form in
    /// JSON, the default conformance to `Decodable` from ``OAuthClaim`` isn't good
    /// enough.
    ///
    /// - Note: The spec is mute on what multi-value claims like `aud` with an
    ///   empty list of values would be considered to represent - whether it
    ///   would be the same as having no claim at all, or represent a token
    ///   making the claim but with zero values. For maximal flexibility, this
    ///   implementation accepts an empty unkeyed container (in JSON, `[]`)
    ///   silently.
    ///
    /// - Note: It would be preferable to be able to safely decode the empty
    ///   array from a lack of _any_ encoded value. This is precluded by the way
    ///   `Codable` works, as either the claim would have to be marked
    ///   optional in the payload, leading to the ambiguity of having both `nil`
    ///   and `[]` representations, each payload type would have to manually
    ///   implement `init(from decoder:)` to use `decodeIfPresent(_:forKey:)`
    ///   and a fallback value, or we would have to export extensions on
    ///   `KeyedEncodingContainer` and `KeyedEncodingContainerProtocol` to
    ///   explicitly override behavior for types confroming to
    ///   ``OAuthMultiValueClaim``, a tricky and error-prone approach relying on
    ///   poorly-understood mechanics of static versus dynamic dispatch.
    ///
    /// - Note: The spec is also mute regarding the behavior of duplicate values
    ///   in a list of more than one. This implementation behaves according to
    ///   the semantics of the particular `Collection` type used as its value;
    ///   `Array` will preserve ordering and duplicates, `Set` will not.
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        do {
            try self.init(value: container.decode(Value.Element.self))
        } catch let DecodingError.typeMismatch(type, context)
            where type == Value.Element.self && context.codingPath.count == container.codingPath.count
        {
            // Unfortunately, `typeMismatch()` doesn't let us explicitly look for what type found,
            // only what type was expected, so we have to match the coding path depth instead.
            try self.init(value: container.decode(Value.self))
        }
    }

    /// This claim can take either singular or plural form in JSON, with the
    /// singular being overwhelmingly more common, so when there is only one
    /// value, ensure it is encoded as a scalar, not an array.
    ///
    /// - Note: As in decoding, the implementation takes a conservative approach
    ///   with regards to the importance of ordering and the handling of
    ///   duplicate values by simply encoding what's there without further
    ///   analysis or filtering.
    ///
    /// - Warning: If the claim has zero values, this implementation will encode
    ///   an inefficient zero-element representation. See the notes regarding
    ///   this on `init(from decoder:)` above.
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self.value.first {
        case let .some(value) where self.value.count == 1:
            try container.encode(value)
        default:
            try container.encode(self.value)
        }
    }
}
