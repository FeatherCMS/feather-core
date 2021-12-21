//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 18..
//

import Vapor

public struct FormFieldValidator<Input: Decodable, Output: TemplateRepresentable>: AsyncValidator {

    public unowned var field: FormField<Input, Output>
    public let message: String
    public let validation: ((FormField<Input, Output>, Request) async throws -> Bool)

    public var key: String { field.key }
    
    public init(_ field: FormField<Input, Output>,
                _ message: String,
                _ validation: @escaping ((FormField<Input, Output>, Request) async throws -> Bool)) {
        self.field = field
        self.message = message
        self.validation = validation
    }

    public func validate(_ req: Request) async throws -> ValidationErrorDetail? {
        let isValid = try await validation(field, req)
        if isValid {
            return nil
        }
        field.error = message
        return error
    }
}
