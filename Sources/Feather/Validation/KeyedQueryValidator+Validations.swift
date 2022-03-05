//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 03. 05..
//

import Vapor

public extension KeyedQueryValidator where T == String {

    static func required(_ key: String, _ message: String? = nil, optional: Bool = false) -> KeyedQueryValidator<T> {
        .init(key, message ?? "\(key.capitalized) is required", optional: optional) { _, value in !value.isEmpty }
    }
        
    static func min(_ key: String, _ length: Int, _ message: String? = nil, optional: Bool = false) -> KeyedQueryValidator<T> {
        .init(key, message ?? "\(key.capitalized) is too short (min: \(length) characters)", optional: optional) { _, value in value.count >= length }
    }
    
    static func max(_ key: String, _ length: Int, _ message: String? = nil, optional: Bool = false) -> KeyedQueryValidator<T> {
        .init(key, message ?? "\(key.capitalized) is too long (max: \(length) characters)", optional: optional) { _, value in value.count <= length }
    }

    static func alphanumeric(_ key: String, _ message: String? = nil, optional: Bool = false) -> KeyedQueryValidator<T> {
        .init(key, message ?? "\(key.capitalized) should be only alphanumeric characters", optional: optional) { _, value in
            !Validator.characterSet(.alphanumerics).validate(value).isFailure
        }
    }

    static func email(_ key: String, _ message: String? = nil, optional: Bool = false) -> KeyedQueryValidator<T> {
        .init(key, message ?? "\(key.capitalized) should be a valid email address", optional: optional) { _, value in
            !Validator.email.validate(value).isFailure
        }
    }
}

public extension KeyedQueryValidator where T == Int {

    static func min(_ key: String, _ length: Int, _ message: String? = nil, optional: Bool = false) -> KeyedQueryValidator<T> {
        .init(key, message ?? "\(key.capitalized) is too short (min: \(length) characters)", optional: optional) { _, value in value >= length }
    }
    
    static func max(_ key: String, _ length: Int, _ message: String? = nil, optional: Bool = false) -> KeyedQueryValidator<T> {
        .init(key, message ?? "\(key.capitalized) is too long (max: \(length) characters)", optional: optional) { _, value in value <= length }
    }

    static func contains(_ key: String, _ values: [Int], _ message: String? = nil, optional: Bool = false) -> KeyedQueryValidator<T> {
        .init(key, message ?? "\(key.capitalized) is an invalid value", optional: optional) { _, value in values.contains(value) }
    }
}

public extension KeyedQueryValidator where T == UUID {

    static func required(_ key: String, _ message: String? = nil, optional: Bool = false) -> KeyedQueryValidator<T> {
        .init(key, message ?? "\(key.capitalized) is required", optional: optional) { _, _ in true }
    }
}
