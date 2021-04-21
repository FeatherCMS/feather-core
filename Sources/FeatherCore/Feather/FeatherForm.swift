//
//  EditForm.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 11. 19..
//

public protocol FeatherForm: FormComponent {
    associatedtype Model: FeatherModel

    var context: FeatherFormContext<Model> { get set }

    init()
}

public extension FeatherForm {

    func encode(to encoder: Encoder) throws {
        try context.encode(to: encoder)
    }
    
    func load(req: Request) -> EventLoopFuture<Void> {
        return context.load(req: req)
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

// NOTE: this requires joined metadata identifier...
public extension FeatherForm where Model: MetadataRepresentable {

    func load(req: Request) -> EventLoopFuture<Void> {
        guard let model = context.model else {
            return context.load(req: req)
        }
        return Model.findMetadata(reference: model.id!, on: req.db).flatMap { metadata -> EventLoopFuture<Void> in
            guard let metadata = metadata else {
                return context.load(req: req)
            }
            context.metadata = metadata
            let baseUrl = "/admin/" + FrontendModule.moduleKey + "/" + FrontendMetadataModel.modelKey + "/" + metadata.id!.uuidString + "/"
            if req.checkPermission(for: FrontendMetadataModel.permission(for: .update)) {
                context.nav.append(.init(label: FrontendMetadataModel.name.singular,
                                         url: baseUrl + FrontendMetadataModel.updatePathComponent.description + "/"))
            }
            else if req.checkPermission(for: FrontendMetadataModel.permission(for: .get)) {
                context.nav.append(.init(label: FrontendMetadataModel.name.singular,
                                         url: baseUrl))
            }
            return context.load(req: req)
        }
    }
}
