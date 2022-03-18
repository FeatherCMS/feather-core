//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 02..
//

import Vapor
import FeatherObjects

public struct KeyedContentValidator<T: Codable>: AsyncValidator {

    public let key: String
    public let message: String
    public let optional: Bool
    public let validation: (Request, T) async throws -> Bool
    
    public init(_ key: String,
                _ message: String,
                optional: Bool = false,
                _ validation: @escaping (Request, T) async throws -> Bool) {
        self.key = key
        self.message = message
        self.optional = optional
        self.validation = validation
    }

    public func validate(_ req: Request) async throws -> FeatherErrorDetail? {
        let optionalValue = try? req.content.get(T.self, at: key)
        if let value = optionalValue {
            return try await validation(req, value) ? nil : error
        }
        return optional ? nil : error
    }
}
