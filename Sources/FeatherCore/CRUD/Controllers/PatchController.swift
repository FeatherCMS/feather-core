//
//  PatchContentController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol PatchApiRepresentable: ModelApi {
    
    associatedtype PatchObject: Content
    
    func validatePatchInput(_ req: Request) -> EventLoopFuture<Bool>
    func processPatchInput(_ req: Request, model: Model, input: PatchObject) -> EventLoopFuture<Model>
}

extension PatchApiRepresentable {

    func validatePatchInput(_ req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
    }

    func processPatchInput(_ req: Request, model: Model, input: PatchObject) -> EventLoopFuture<Model> {
        return req.eventLoop.future(model)
    }
}


public protocol PatchController: IdentifiableController {
    
    associatedtype PatchApi: PatchApiRepresentable & GetApiRepresentable
    
    func accessPatch(req: Request) -> EventLoopFuture<Bool>
//    func beforePatch(req: Request, model: Model, content: Model.PatchContent) -> EventLoopFuture<Model>
    func patchApi(_ req: Request) throws -> EventLoopFuture<PatchApi.GetObject>
    func afterPatch(req: Request, model: Model) -> EventLoopFuture<Void>
    func setupPatchApiRoute(on: RoutesBuilder)
}

public extension PatchController {

    func accessPatch(req: Request) -> EventLoopFuture<Bool> {
        req.checkAccess(for: Model.permission(for: .patch))
    }

//    func beforePatch(req: Request, model: Model, content: Model.PatchContent) -> EventLoopFuture<Model> {
//        req.eventLoop.future(model)
//    }
//
    func patchApi(_ req: Request) throws -> EventLoopFuture<PatchApi.GetObject> {
        accessPatch(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            return req.eventLoop.future(error: Abort(.forbidden))
            
//            try Model.PatchContent.validate(content: req)
//            let patch = try req.content.decode(Model.PatchContent.self)
//            return try findBy(identifier(req), on: req.db)
//                .flatMap { beforePatch(req: req, model: $0, content: patch) }
//                .flatMapThrowing { model -> Model in
//                    try model.patch(patch)
//                    return model
//                }
//                .flatMap { model -> EventLoopFuture<Model.GetContent> in
//                    return model.update(on: req.db)
//                        .flatMap { afterPatch(req: req, model: model) }
//                        .transform(to: model.getContent)
//                }
        }
    }

    func afterPatch(req: Request, model: Model) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }

    func setupPatchApiRoute(on builder: RoutesBuilder) {
        builder.patch(idPathComponent, use: patchApi)
    }
}
