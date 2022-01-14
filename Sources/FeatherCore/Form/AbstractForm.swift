//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 26..
//

open class AbstractForm: FormEventResponder {

    struct FormInput: Decodable {
        let formId: String
        let formToken: String
    }
    
    open var id: String
    open var token: String
    open var action: FormAction
    open var error: String?
    open var submit: String?
    open var fields: [FormField] {
        didSet {
            if !fields.filter({ $0 is ImageField || $0 is MultipleFileField /*|| $0 is FileField*/ }).isEmpty {
                action.enctype = .multipart
            }
        }
    }

    public init(id: String = UUID().string,
                token: String = UUID().string,
                action: FormAction = .init(),
                error: String? = nil,
                submit: String? = nil,
                fields: [FormField] = []) {
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

    @FormFieldBuilder
    open func createFields() -> [FormField] {
        
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
    
    // MARK: - FormField

    open func load(req: Request) async throws {
        token = req.generateNonce(for: id)
        try await fields.forEachAsync { try await $0.load(req: req) }
    }

    open func process(req: Request) async throws {
        try await fields.forEachAsync { field in
            try await field.process(req: req)
        }
    }
    
    open func validate(req: Request) async throws -> Bool {
        do {
            try validateToken(req)
        }
        catch {
            self.error = "Invalid form token"
            return false
        }
        let result = try await fields.mapAsync { try await $0.validate(req: req) }
        return result.filter { $0 == false }.isEmpty
    }

    open func save(req: Request) async throws {
        try await fields.forEachAsync { try await $0.save(req: req) }
    }
    
    open func read(req: Request) async throws {
        try await fields.forEachAsync { try await $0.read(req: req) }
    }

    open func write(req: Request) async throws {
        try await fields.forEachAsync { try await $0.write(req: req) }
    }
    
    open func render(req: Request) -> TemplateRepresentable {
        return FormTemplate(context(req))
    }
    
}
