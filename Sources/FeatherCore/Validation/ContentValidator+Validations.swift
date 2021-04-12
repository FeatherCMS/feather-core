//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 02..
//

public extension ContentValidator {

    static func required(key: String, message: String? = nil) -> ContentValidator<T> {
        .init(key: key, message: message ?? "\(key.lowercased().capitalized) is required")
    }
}

public extension ContentValidator where T == String {

    static func required(key: String, message: String? = nil) -> ContentValidator<T> {
        .init(key: key, message: message ?? "\(key.lowercased().capitalized) is required", validation: { !$0.isEmpty })
    }
        
    static func min(key: String, length: Int, message: String? = nil) -> ContentValidator<T> {
        .init(key: key, message: message ?? "\(key.lowercased().capitalized) is too short (min: \(length) characters)", validation: { $0.count >= length })
    }
    
    static func max(key: String, length: Int, message: String? = nil) -> ContentValidator<T> {
        .init(key: key, message: message ?? "\(key.lowercased().capitalized) is too long (max: \(length) characters)", validation: { $0.count <= length })
    }

    static func alphanumeric(key: String, message: String? = nil) -> ContentValidator<T> {
        .init(key: key, message: message ?? "\(key.lowercased().capitalized) should be only alphanumeric characters", validation: { Validator.characterSet(.alphanumerics).validate($0).isFailure
        })
    }

    static func email(key: String, message: String? = nil) -> ContentValidator<T> {
        .init(key: key, message: message ?? "\(key.lowercased().capitalized) should be a valid email address", validation: {
            Validator.email.validate($0).isFailure
        })
    }
}

public extension ContentValidator where T == Int {

    static func min(key: String, length: Int, message: String? = nil) -> ContentValidator<T> {
        .init(key: key, message: message ?? "\(key.lowercased().capitalized) is too short (min: \(length) characters)", validation: { $0 >= length })
    }
    
    static func max(key: String, length: Int, message: String? = nil) -> ContentValidator<T> {
        .init(key: key, message: message ?? "\(key.lowercased().capitalized) is too long (max: \(length) characters)", validation: { $0 <= length })
    }

    static func contains(key: String, values: [Int], message: String? = nil) -> ContentValidator<T> {
        .init(key: key, message: message ?? "\(key.lowercased().capitalized) is an invalid value", validation: { values.contains($0) })
    }
}
