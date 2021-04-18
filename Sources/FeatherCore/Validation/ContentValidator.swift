//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 02..
//

public struct ContentValidator<T: Codable>: AsyncValidator {

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
    
    public func validate(_ req: Request) -> EventLoopFuture<ValidationError?> {
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


public struct FormFieldValidator<Input: Decodable, Output: FormFieldView>: AsyncValidator {

    public unowned var field: FormField<Input, Output>
    public let message: String
    public var key: String { field.key }


    public let validation: ((FormField<Input, Output>) -> Bool)?
    public let asyncValidation: ((FormField<Input, Output>, Request) -> EventLoopFuture<Bool>)?
    
    public init(_ field: FormField<Input, Output>,
                _ message: String,
                _ validation: ((FormField<Input, Output>) -> Bool)? = nil,
                _ asyncValidation: ((FormField<Input, Output>, Request) -> EventLoopFuture<Bool>)? = nil) {
        self.field = field
        self.message = message
        self.validation = validation
        self.asyncValidation = asyncValidation
    }
    
    public func validate(_ req: Request) -> EventLoopFuture<ValidationError?> {
        var future: EventLoopFuture<ValidationError?> = req.eventLoop.future(nil)
        if let validation = validation {
            future = req.eventLoop.future(validation(field) ? nil : error)
        }
        if let asyncValidation = asyncValidation {
            future = asyncValidation(field, req).map { $0 ? nil : error }
        }
        return future.map { [unowned field] result in
            guard result == nil else {
                return result
            }
            field.output.error = message
            return result
        }
    }
}

