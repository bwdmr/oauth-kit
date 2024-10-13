/// An extremely specialized `Decoder` whose only purpose is to spoon-feed the
/// type being decoded a single unkeyed element. This ridiculously intricate
/// workaround is used to get around the problem of `Collection` not having any
/// initializers for the single-value initializer of ``OAuthMultiValueClaim``. The
/// other workaround would be to require conformance to
/// `ExpressibleByArrayLiteral`, but what fun would that be?
struct CollectionOfOneDecoder<T>: Decoder, UnkeyedDecodingContainer where T: Collection, T: Codable, T.Element: Codable {
    static func decode(_ element: T.Element) throws -> T {
        return try T(from: self.init(value: element))
    }

    /// The single value we're returning.
    var value: T.Element

    /// The `currentIndex` for ``UnkeyedDecodingContainer``.
    var currentIndex: Int = 0

    /// We are our own unkeyed decoding container.
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return self
    }

    /// Standard `decodeNil()` implementation. We could ask the value for its
    /// `nil`-ness, but returning `false` unconditionally will cause `Codable`
    /// to just defer to `Optional`'s decodable implementation anyway.
    mutating func decodeNil() throws -> Bool {
        return false
    }

    /// Standard `decode<T>(_:)` implementation. If the type is correct, we
    /// return our singular value, otherwise error. We throw nice errors instead
    /// of using `fatalError()` mostly just in case someone implemented a
    /// ``Collection`` with a really weird `Decodable` conformance.
    mutating func decode<U>(_: U.Type) throws -> U where U: Decodable {
        guard !self.isAtEnd else {
            throw DecodingError.valueNotFound(U.self, .init(codingPath: [], debugDescription: "Unkeyed container went past the end?"))
        }

        guard U.self == T.Element.self else {
            throw DecodingError.typeMismatch(U.self, .init(codingPath: [], debugDescription: "Asked for the wrong type!"))
        }

        self.currentIndex += 1
        return value as! U
    }

    /// The error we throw for all operations we don't support (which is most of them).
    private var unsupportedError: DecodingError {
        return DecodingError.typeMismatch(Any.self, .init(codingPath: [], debugDescription: "This decoder doesn't support most things."))
    }

    // ``Decoder`` and ``UnkeyedDecodingContainer`` conformance requirements. We don't bother tracking any coding path or
    // user info and we just fail instantly if asked for anything other than an unnested unkeyed container. The count
    // of the unkeyed container is always exactly one.

    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]
    var isAtEnd: Bool { currentIndex != 0 }
    var count: Int? = 1

    func container<Key>(keyedBy _: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        throw self.unsupportedError
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        throw self.unsupportedError
    }

    mutating func nestedContainer<N>(keyedBy _: N.Type) throws -> KeyedDecodingContainer<N> where N: CodingKey {
        throw self.unsupportedError
    }

    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw self.unsupportedError
    }

    mutating func superDecoder() throws -> Decoder {
        throw self.unsupportedError
    }
}
