//
//  EditForm.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 11. 19..
//


open class ModelForm<T: FeatherModel>: Form, FeatherForm {
        
    public typealias Model = T

    enum CodingKeys: CodingKey {
        case nav
        case model
        
        case action
        case id
        case token
        case title
        case notification
        case fields
    }

    open var nav: [Link]
    open var model: T?
    
    private var modelInfo: ModelInfo?

    public convenience required init() {
        self.init(model: nil)
    }

    init(model: T? = nil, nav: [Link] = []) {
        self.model = model
        self.nav = nav

        super.init()

        self.title = Model.name

        self.initialize()
    }
    
    open func initialize() {
        
    }
    
    open override func initialize(req: Request) -> EventLoopFuture<Void> {
        modelInfo = Model.info(req)
        return super.initialize(req: req)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(modelInfo, forKey: .model)
        try container.encode(nav, forKey: .nav)
        
        /// NOTE: can't call super.encode(to:) due to a Tau super encoder bug... need to fix that later on
        try container.encode(action, forKey: .action)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(token, forKey: .token)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(notification, forKey: .notification)

        var fieldsArrayContainer = container.superEncoder(forKey: .fields).unkeyedContainer()
        for field in fields {
            try field.encode(to: fieldsArrayContainer.superEncoder())
        }
    }
}
