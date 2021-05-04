//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 02..
//

public struct KeyedContentValidator<T: Codable>: AsyncValidator {

    public let key: String
    public let message: String
    public let optional: Bool

    public let validation: ((T) -> Bool)?
    public let asyncValidation: ((T, Request) -> EventLoopFuture<Bool>)?
    
    public init(key: String,
                message: String,
                optional: Bool = false,
                validation: ((T) -> Bool)? = nil,
                asyncValidation: ((T, Request) -> EventLoopFuture<Bool>)? = nil) {
        self.key = key
        self.message = message
        self.optional = optional
        self.validation = validation
        self.asyncValidation = asyncValidation
    }
    
    public func validate(_ req: Request) -> EventLoopFuture<ValidationErrorDetail?> {
        let optionalValue = try? req.content.get(T.self, at: key)

        if let value = optionalValue {
            if let validation = validation {
                return req.eventLoop.future(validation(value) ? nil : error)
            }
            if let asyncValidation = asyncValidation {
                return asyncValidation(value, req).map { $0 ? nil : error }
            }
            return req.eventLoop.future(nil)
        }
        else {
            if optional {
                return req.eventLoop.future(nil)
            }
            return req.eventLoop.future(error)
        }
    }
}


