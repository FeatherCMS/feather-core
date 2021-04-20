//
//  EditForm.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 11. 19..
//


public protocol EditFormController: FormComponent {
    associatedtype Model: FeatherModel

    var context: EditFormContext<Model> { get set }

    init()
}

public extension EditFormController {

    func encode(to encoder: Encoder) throws {
        try context.encode(to: encoder)
    }
    
    func load(req: Request) -> EventLoopFuture<Void> {
        context.load(req: req)
    }
    
    func process(req: Request) -> EventLoopFuture<Void> {
        context.process(req: req)
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        context.validate(req: req)
    }
    
    func write(req: Request) -> EventLoopFuture<Void> {
        context.write(req: req)
    }
    
    func save(req: Request) -> EventLoopFuture<Void> {
        context.save(req: req)
    }
    
    func read(req: Request) -> EventLoopFuture<Void> {
        context.read(req: req)
    }
}
