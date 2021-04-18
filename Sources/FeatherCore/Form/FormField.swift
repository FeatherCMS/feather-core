//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//


open class FormField<Input: Decodable, Output: Encodable>: FormComponent {

    public typealias FormFieldValidatorsHandler = ((Request, FormField<Input, Output>) -> [AsyncValidator])
    public typealias FormFieldHandler = (Request, FormField<Input, Output>) throws -> Void
    public typealias FormFieldAsyncHandler = (Request, FormField<Input, Output>) -> EventLoopFuture<Void>
//    public typealias FormFieldAsyncBoolHandler = (Request, FormField<Input, Output>) -> EventLoopFuture<Bool>
    
    
    public var key: String
    public var input: Input
    public var output: Output
    
    private var initHandler: FormFieldAsyncHandler?
    private var processHandler: FormFieldHandler?
    private var validatorsHandler: FormFieldValidatorsHandler?
//    private var validationHandler: FormFieldAsyncBoolHandler?
    private var loadHandler: FormFieldAsyncHandler?
    private var saveHandler: FormFieldAsyncHandler?
    private var renderHandler: FormFieldHandler?
    
    public init(key: String, input: Input, output: Output) {
        self.key = key
        self.input = input
        self.output = output
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(output)
    }

    // MARK: - open api
    
    open func config(_ block: (FormField<Input, Output>) -> Void) -> Self {
        block(self)
        return self
    }

    open func onInitialize(_ block: @escaping FormFieldAsyncHandler) -> Self {
        initHandler = block
        return self
    }
    
    open func onProcess(_ block: @escaping FormFieldHandler) -> Self {
        processHandler = block
        return self
    }
    
    open func validators(_ block: @escaping FormFieldValidatorsHandler) -> Self {
        validatorsHandler = block
        return self
    }

//    open func onValidation(_ block: @escaping FormFieldAsyncBoolHandler) -> Self {
//        validationHandler = block
//        return self
//    }
    
    open func onLoad(_ block: @escaping FormFieldAsyncHandler) -> Self {
        loadHandler = block
        return self
    }
    
    open func onSave(_ block: @escaping FormFieldAsyncHandler) -> Self {
        saveHandler = block
        return self
    }

    open func onRender(_ block: @escaping FormFieldHandler) -> Self {
        renderHandler = block
        return self
    }
    
    // MARK: - api
    
    public func initialize(req: Request) -> EventLoopFuture<Void> {
        initHandler?(req, self) ?? req.eventLoop.future()
    }
    
    public func process(req: Request) throws {
        try processHandler?(req, self)
    }

    public func validate(req: Request) -> EventLoopFuture<Bool> {
        guard let validators = validatorsHandler else {
            return req.eventLoop.future(true)
        }
        return InputValidator(validators(req, self)).validate(req)
    }
    
    public func load(req: Request) -> EventLoopFuture<Void> {
        loadHandler?(req, self) ?? req.eventLoop.future()
    }
    
    public func save(req: Request) -> EventLoopFuture<Void> {
        saveHandler?(req, self) ?? req.eventLoop.future()
    }
    
    public func render(req: Request) throws {
        try renderHandler?(req, self)
    }
    
    
}
