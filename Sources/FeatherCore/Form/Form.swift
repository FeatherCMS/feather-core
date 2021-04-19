//
//  Form.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//


open class Form: FormComponent {

    public struct Action: Encodable {
        public enum Method: String, Encodable {
            case get
            case post
        }
        public let method: Method
        public let url: String?
        public var multipart: Bool
        
        public init(method: Method = .post,
                    url: String? = nil,
                    multipart: Bool = false) {
            self.method = method
            self.url = url
            self.multipart = multipart
        }
    }
    
    enum CodingKeys: CodingKey {
        case action
        case id
        case token
        case title
        case notification
        case fields
    }

    open var action: Action
    open var id: String
    open var token: String
    open var title: String
    open var notification: Notification?
    open var fields: [FormComponent]
    
    init(action: Action = .init(),
         id: String = UUID().uuidString,
         token: String = UUID().uuidString,
         title: String = "form",
         notification: Notification? = nil,
         fields: [FormComponent] = []) {
        
        self.action = action
        self.id = id
        self.token = token
        self.title = title
        self.notification = notification
        self.fields = fields
        
        self.initialize()
    }
    
    open func initialize() {
        
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
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

    // MARK: - fields api

    func loadFields(req: Request) -> EventLoopFuture<Void> {
        req.eventLoop.flatten(fields.map { $0.load(req: req) })
    }

    func processFields(req: Request) -> EventLoopFuture<Void> {
        req.eventLoop.flatten(fields.map { $0.process(req: req) })
    }
    
    func validateFields(req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.mergeTrueFutures(fields.map { $0.validate(req: req) })
    }

    func saveFields(req: Request) -> EventLoopFuture<Void> {
        req.eventLoop.flatten(fields.map { $0.save(req: req) })
    }
    
    func readFields(req: Request) -> EventLoopFuture<Void> {
        req.eventLoop.flatten(fields.map { $0.read(req: req) })
    }

    func writeFields(req: Request) -> EventLoopFuture<Void> {
        req.eventLoop.flatten(fields.map { $0.write(req: req) })
    }
    
    
    // MARK: - open api

    
    open func load(req: Request) -> EventLoopFuture<Void> {
        token = req.generateNonce(for: "form", id: id)
        return loadFields(req: req)
    }
    
    open func process(req: Request) -> EventLoopFuture<Void> {
        processFields(req: req)
    }
    
    open func validate(req: Request) -> EventLoopFuture<Bool> {
        validateFields(req: req)
    }

    open func save(req: Request) -> EventLoopFuture<Void> {
        saveFields(req: req)
    }

    open func read(req: Request) -> EventLoopFuture<Void> {
        readFields(req: req)
    }
    
    open func write(req: Request) -> EventLoopFuture<Void> {
        writeFields(req: req)
    }
}

