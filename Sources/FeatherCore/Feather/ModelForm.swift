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
public extension EditFormController where Model: MetadataRepresentable {

    func load(req: Request) -> EventLoopFuture<Void> {
        guard let model = context.model else {
            return context.load(req: req)
        }
        return Model.findMetadata(reference: model.id!, on: req.db).flatMap { metadata -> EventLoopFuture<Void> in
            guard let metadata = metadata else {
                return context.load(req: req)
            }
            context.metadata = metadata
            if req.checkPermission(for: SystemMetadataModel.permission(for: .update)) {
                context.nav.append(.init(label: "Metadata", url: "/admin/system/metadatas/" + metadata.id!.uuidString + "/update/"))
            }
            else if req.checkPermission(for: SystemMetadataModel.permission(for: .get)) {
                context.nav.append(.init(label: "Metadata", url: "/admin/system/metadatas/" + metadata.id!.uuidString))
            }
            return context.load(req: req)
        }
    }
}
