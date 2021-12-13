//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 02..
//

import Vapor

public struct KeyedContentValidator<T: Codable>: AsyncValidator {

    public let key: String
    public let message: String
    public let optional: Bool
    public let validation: (T, Request) async -> Bool
    
    public init(_ key: String,
                _ message: String,
                optional: Bool = false,
                _ validation: @escaping (T, Request) async -> Bool) {
        self.key = key
        self.message = message
        self.optional = optional
        self.validation = validation
    }

    public func validate(_ req: Request) async -> ValidationErrorDetail? {
        let optionalValue = try? req.content.get(T.self, at: key)

        if let value = optionalValue {
            return await validation(value, req) ? nil : error
        }
        return optional ? nil : error
    }
}
