//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//


open class FormField<Input: Decodable, Outuput: Encodable>: FormComponent {

    public typealias FormFieldHandler = (Request, FormField<Input, Outuput>) throws -> Void
    public typealias FormFieldAsyncHandler = (Request, FormField<Input, Outuput>) -> EventLoopFuture<Void>
    public typealias FormFieldAsyncBoolHandler = (Request, FormField<Input, Outuput>) -> EventLoopFuture<Bool>
    
    
    public var key: String
    public var input: Input
    public var output: Outuput
    
    private var initHandler: FormFieldAsyncHandler?
    private var processHandler: FormFieldHandler?
    private var validationHandler: FormFieldAsyncBoolHandler?
    private var loadHandler: FormFieldAsyncHandler?
    private var saveHandler: FormFieldAsyncHandler?
    private var renderHandler: FormFieldHandler?
    
    public init(key: String, input: Input, output: Outuput) {
        self.key = key
        self.input = input
        self.output = output
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        try container.encode(output)
//        print(output.encodeToTemplateData())
//        try output.encode(to: encoder)
    }

    // MARK: - open api

    open func onInitialize(_ block: @escaping FormFieldAsyncHandler) -> Self {
        initHandler = block
        return self
    }
    
    open func onProcess(_ block: @escaping FormFieldHandler) -> Self {
        processHandler = block
        return self
    }
    
    open func onValidation(_ block: @escaping FormFieldAsyncBoolHandler) -> Self {
        validationHandler = block
        return self
    }
    
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
        validationHandler?(req, self) ?? req.eventLoop.future(true)
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





