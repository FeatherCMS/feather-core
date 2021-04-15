//
//  Form.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

public protocol Form: AnyObject {

    /// form fields
    var fields: [FormFieldRepresentable] { get }
    /// template data representation of the form fields
    var fieldsTemplateData: TemplateData { get }
    
    /// generic notification
    var notification: String? { get set }

    init()

    /// initialize form values asynchronously
    func initialize(req: Request) -> EventLoopFuture<Void>
    
    /// process input value from an incoming request
    func processFields(req: Request)

    /// process request from an incoming request
    func process(req: Request) -> EventLoopFuture<Void>

    /// process input value from an incoming request
    func processAfterFields(req: Request) -> EventLoopFuture<Void>

    /// validate form fields
    func validateFields(req: Request) -> EventLoopFuture<Bool>
    /// validate after field validation happened
    func validateAfterFields(req: Request) -> EventLoopFuture<Bool>
    /// validate the entire form
    func validate(req: Request) -> EventLoopFuture<Bool>

    func save(req: Request) -> EventLoopFuture<Void>
}

public extension Form {
    
    var fields: [FormFieldRepresentable] { [] }

    var fieldsTemplateData: TemplateData {
        .array(fields.map(\.templateData))
//        .dictionary(fields.reduce(into: [String: TemplateData]()) { $0[$1.key] = $1.templateData })
    }

    var templateData: TemplateData {
        .dictionary([
            "fields": fieldsTemplateData,
            "notification": .string(notification)
        ])
    }
    
    func initialize(req: Request) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }
    
    func processFields(req: Request) {
        for field in fields {
            field.process(req: req)
        }
    }

    func processAfterFields(req: Request) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }

    func process(req: Request) -> EventLoopFuture<Void> {
        processFields(req: req)
        return processAfterFields(req: req)
    }
    
    func validateFields(req: Request) -> EventLoopFuture<Bool> {
        let futures = fields.map { $0.validate(req: req) }
        return req.eventLoop.mergeTrueFutures(futures)
    }

    func validateAfterFields(req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
    }

    func validate(req: Request) -> EventLoopFuture<Bool> {
        return validateFields(req: req).flatMap { [unowned self] result in
            guard result else {
                return req.eventLoop.future(false)
            }
            return validateAfterFields(req: req)
        }
    }

    func save(req: Request) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }
}
