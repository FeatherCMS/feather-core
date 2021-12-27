//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 26..
//

open class FormField<Input: Decodable, Output: TemplateRepresentable>: FormComponent {
    
    public typealias FormFieldBlock = (Request, FormField<Input, Output>) -> Void
    public typealias AsyncFormFieldBlock = (Request, FormField<Input, Output>) async throws -> Void
    public typealias FormFieldValidatorsBlock = ((Request, FormField<Input, Output>) -> [AsyncValidator])
    
    public var key: String
    public var input: Input
    public var output: Output
    public var error: String?

    var loadBlock: AsyncFormFieldBlock?
    var processBlock: AsyncFormFieldBlock?
    var validatorsBlock: FormFieldValidatorsBlock?
    var readBlock: AsyncFormFieldBlock?
    var writeBlock: AsyncFormFieldBlock?
    var saveBlock: AsyncFormFieldBlock?
    
    public init(key: String, input: Input, output: Output, error: String? = nil) {
        self.key = key
        self.input = input
        self.output = output
        self.error = error
    }
    
    open func config(_ block: (FormField<Input, Output>) -> Void) -> Self {
        block(self)
        return self
    }

    // MARK: -
    
    open func load(_ block: @escaping FormFieldBlock) -> Self {
        loadBlock = { req, field in
            block(req, field)
        }
        return self
    }
    
    open func load(_ block: @escaping AsyncFormFieldBlock) -> Self {
        loadBlock = block
        return self
    }
    
    open func process(_ block: @escaping AsyncFormFieldBlock) -> Self {
        processBlock = block
        return self
    }
    
    open func validators(@AsyncValidatorBuilder _ block: @escaping FormFieldValidatorsBlock) -> Self {
        validatorsBlock = block
        return self
    }
    
    open func write(_ block: @escaping FormFieldBlock) -> Self {
        writeBlock = { req, field in
            block(req, field)
        }
        return self
    }
    
    open func write(_ block: @escaping AsyncFormFieldBlock) -> Self {
        writeBlock = block
        return self
    }

    open func save(_ block: @escaping AsyncFormFieldBlock) -> Self {
        saveBlock = block
        return self
    }
    
    open func save(_ block: @escaping FormFieldBlock) -> Self {
        saveBlock = { req, field in
            block(req, field)
        }
        return self
    }
    
    open func read(_ block: @escaping FormFieldBlock) -> Self {
        readBlock = { req, field in
            block(req, field)
        }
        return self
    }
    
    open func read(_ block: @escaping AsyncFormFieldBlock) -> Self {
        readBlock = block
        return self
    }
    
    // MARK: -

    public func load(req: Request) async throws {
        try await loadBlock?(req, self)
    }
    
    public func process(req: Request) async throws {
        if let value = try? req.content.get(Input.self, at: key) {
            input = value
        }
        try await processBlock?(req, self)
    }
    
    public func validate(req: Request) async throws -> Bool {
        guard let validators = validatorsBlock else {
            return true
        }
        return await RequestValidator(validators(req, self)).isValid(req)
    }
    
    open func write(req: Request) async throws {
        try await writeBlock?(req, self)
    }

    public func save(req: Request) async throws {
        try await saveBlock?(req, self)
    }
    
    open func read(req: Request) async throws {
        try await readBlock?(req, self)
    }
    
    open func render(req: Request) -> TemplateRepresentable {
        output
    }
}
