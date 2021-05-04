//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 02..
//

public extension KeyedContentValidator where T == String {

    static func required(_ key: String, _ message: String? = nil, optional: Bool = false) -> KeyedContentValidator<T> {
        .init(key, message ?? "\(key.uppercasedFirst) is required", optional: optional) { !$0.isEmpty }
    }
        
    static func min(_ key: String, _ length: Int, _ message: String? = nil, optional: Bool = false) -> KeyedContentValidator<T> {
        .init(key, message ?? "\(key.uppercasedFirst) is too short (min: \(length) characters)", optional: optional) { $0.count >= length }
    }
    
    static func max(_ key: String, _ length: Int, _ message: String? = nil, optional: Bool = false) -> KeyedContentValidator<T> {
        .init(key, message ?? "\(key.uppercasedFirst) is too long (max: \(length) characters)", optional: optional) { $0.count <= length }
    }

    static func alphanumeric(_ key: String, _ message: String? = nil, _ optional: Bool = false) -> KeyedContentValidator<T> {
        .init(key, message ?? "\(key.uppercasedFirst) should be only alphanumeric characters", optional: optional) {
            Validator.characterSet(.alphanumerics).validate($0).isFailure
        }
    }

    static func email(_ key: String, _ message: String? = nil, _ optional: Bool = false) -> KeyedContentValidator<T> {
        .init(key, message ?? "\(key.uppercasedFirst) should be a valid email address", optional: optional) {
            Validator.email.validate($0).isFailure
        }
    }
}

public extension KeyedContentValidator where T == Int {

    static func min(_ key: String, _ length: Int, _ message: String? = nil, optional: Bool = false) -> KeyedContentValidator<T> {
        .init(key, message ?? "\(key.uppercasedFirst) is too short (min: \(length) characters)", optional: optional) { $0 >= length }
    }
    
    static func max(_ key: String, _ length: Int, _ message: String? = nil, optional: Bool = false) -> KeyedContentValidator<T> {
        .init(key, message ?? "\(key.uppercasedFirst) is too long (max: \(length) characters)", optional: optional) { $0 <= length }
    }

    static func contains(_ key: String, _ values: [Int], _ message: String? = nil, optional: Bool = false) -> KeyedContentValidator<T> {
        .init(key, message ?? "\(key.uppercasedFirst) is an invalid value", optional: optional) { values.contains($0) }
    }
}
