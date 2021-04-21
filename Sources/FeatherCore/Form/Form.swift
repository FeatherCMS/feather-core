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
        case error
        case fields
    }

    open var action: Action
    open var id: String
    open var token: String
    open var title: String
    open var notification: Notification?
    open var error: String?
    open var fields: [FormComponent] {
        didSet {
            /// NOTE: maybe a requiresMultipart: Bool FormComponent protocol property would be a better idea... ?
            self.action.multipart = fields.reduce(false, { $0 || ($1 is ImageField /*|| $1 is FileField*/) })
        }
    }

    public init(action: Action = .init(),
                id: String = UUID().uuidString,
                token: String = UUID().uuidString,
                title: String = "form",
                notification: Notification? = nil,
                error: String? = nil,
                fields: [FormComponent] = []) {
        
        self.action = action
        self.id = id
        self.token = token
        self.title = title
        self.notification = notification
        self.error = error
        self.fields = fields
    }

    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(action, forKey: .action)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(token, forKey: .token)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(notification, forKey: .notification)
        try container.encodeIfPresent(error, forKey: .error)

        var fieldsArrayContainer = container.superEncoder(forKey: .fields).unkeyedContainer()
        for field in fields {
            try field.encode(to: fieldsArrayContainer.superEncoder())
        }
    }
    
    // MARK: - form component
    
    open func load(req: Request) -> EventLoopFuture<Void> {
        req.eventLoop.flatten(fields.map { $0.load(req: req) })
    }

    open func process(req: Request) -> EventLoopFuture<Void> {
        req.eventLoop.flatten(fields.map { $0.process(req: req) })
    }
    
    open func validate(req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.mergeTrueFutures(fields.map { $0.validate(req: req) })
    }

    open func save(req: Request) -> EventLoopFuture<Void> {
        req.eventLoop.flatten(fields.map { $0.save(req: req) })
    }
    
    open func read(req: Request) -> EventLoopFuture<Void> {
        req.eventLoop.flatten(fields.map { $0.read(req: req) })
    }

    open func write(req: Request) -> EventLoopFuture<Void> {
        req.eventLoop.flatten(fields.map { $0.write(req: req) })
    }
}
