//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 26..
//

import Vapor
import SwiftHtml

open class FeatherForm: FormComponent {    

    open var id: String
    open var token: String
    open var action: FormAction
    open var error: String?
    open var submit: String?
    open var fields: [FormComponent] {
        didSet {
            if !fields.filter({ $0 is ImageField }).isEmpty {
                action.enctype = .multipart
            }
        }
    }

    public init(id: String = UUID().uuidString,
                token: String = UUID().uuidString,
                action: FormAction = .init(),
                error: String? = nil,
                submit: String? = nil,
                fields: [FormComponent] = []) {
        self.id = id
        self.token = token
        self.action = action
        self.error = error
        self.submit = submit
        self.fields = fields

        if self.fields.isEmpty {
            self.fields = createFields()
        }
    }
    
    @FormComponentBuilder
    open func createFields() -> [FormComponent] {
        
    }

    public func validateToken(_ req: Request) throws {
        let context = try req.content.decode(FormInput.self)
        try req.useNonce(id: context.formId, token: context.formToken)
    }
    
    public func context(_ req: Request) -> FormContext {
        .init(id: id,
              token: token,
              action: action,
              error: error,
              submit: submit,
              fields: fields.map { $0.render(req: req) })
    }
    
    // MARK: - FormComponent

    open func load(req: Request) async {
        token = req.generateNonce(for: id)
        await fields.asyncForEach { await $0.load(req: req) }
    }

    open func process(req: Request) async {
        await fields.asyncForEach { field in
            await field.process(req: req)
        }
    }
    
    open func validate(req: Request) async -> Bool {
        do {
            try validateToken(req)
        }
        catch {
            self.error = "Invalid form token"
            return false
        }
        let result = await fields.asyncMap { await $0.validate(req: req) }
        return result.filter { $0 == false }.isEmpty
    }

    open func save(req: Request) async {
        await fields.asyncForEach { await $0.save(req: req) }
    }
    
    open func read(req: Request) async {
        await fields.asyncForEach { await $0.read(req: req) }
    }

    open func write(req: Request) async {
        await fields.asyncForEach { await $0.write(req: req) }
    }
    
    open func render(req: Request) -> TemplateRepresentable {
        return FormTemplate(req, context(req))
    }
    
}
