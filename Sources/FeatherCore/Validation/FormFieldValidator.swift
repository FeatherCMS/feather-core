//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 18..
//

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
                field.output.error = message
                return result
            }
            return result
        }
    }
}
