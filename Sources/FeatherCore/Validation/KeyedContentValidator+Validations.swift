//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 02..
//

public extension KeyedContentValidator where T == String {

    static func required(key: String, message: String? = nil, optional: Bool = false) -> KeyedContentValidator<T> {
        .init(key: key,
              message: message ?? "\(key.uppercasedFirst) is required",
              optional: optional,
              validation: { !$0.isEmpty })
    }
        
    static func min(key: String, length: Int, message: String? = nil, optional: Bool = false) -> KeyedContentValidator<T> {
        .init(key: key,
              message: message ?? "\(key.uppercasedFirst) is too short (min: \(length) characters)",
              optional: optional,
              validation: { $0.count >= length })
    }
    
    static func max(key: String, length: Int, message: String? = nil, optional: Bool = false) -> KeyedContentValidator<T> {
        .init(key: key, message: message ?? "\(key.uppercasedFirst) is too long (max: \(length) characters)", optional: optional, validation: { $0.count <= length })
    }

    static func alphanumeric(key: String, message: String? = nil, optional: Bool = false) -> KeyedContentValidator<T> {
        .init(key: key,
              message: message ?? "\(key.uppercasedFirst) should be only alphanumeric characters",
              optional: optional,
              validation: { Validator.characterSet(.alphanumerics).validate($0).isFailure })
    }

    static func email(key: String, message: String? = nil, optional: Bool = false) -> KeyedContentValidator<T> {
        .init(key: key,
              message: message ?? "\(key.uppercasedFirst) should be a valid email address",
              optional: optional,
              validation: { Validator.email.validate($0).isFailure })
    }
}

public extension KeyedContentValidator where T == Int {

    static func min(key: String, length: Int, message: String? = nil, optional: Bool = false) -> KeyedContentValidator<T> {
        .init(key: key,
              message: message ?? "\(key.uppercasedFirst) is too short (min: \(length) characters)",
              optional: optional,
              validation: { $0 >= length })
    }
    
    static func max(key: String, length: Int, message: String? = nil, optional: Bool = false) -> KeyedContentValidator<T> {
        .init(key: key,
              message: message ?? "\(key.uppercasedFirst) is too long (max: \(length) characters)",
              optional: optional,
              validation: { $0 <= length })
    }

    static func contains(key: String, values: [Int], message: String? = nil, optional: Bool = false) -> KeyedContentValidator<T> {
        .init(key: key,
              message: message ?? "\(key.uppercasedFirst) is an invalid value",
              optional: optional,
              validation: { values.contains($0) })
    }
}
