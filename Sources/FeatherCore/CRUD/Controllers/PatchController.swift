//
//  PatchContentController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol PatchApiRepresentable: ModelApi {
    
    associatedtype PatchObject: Content
    
    func patchValidators() -> [AsyncValidator]
    func mapPatch(_ req: Request, model: Model, input: PatchObject) -> EventLoopFuture<Void>
}
extension PatchApiRepresentable {
    func patchValidators() -> [AsyncValidator] { [] }
}

public protocol PatchController: IdentifiableController {
    
    associatedtype PatchApi: PatchApiRepresentable & GetApiRepresentable
    
    func accessPatch(req: Request) -> EventLoopFuture<Bool>
    func beforePatch(req: Request, model: Model) -> EventLoopFuture<Void>
    func patchApi(_ req: Request) throws -> EventLoopFuture<PatchApi.GetObject>
    func afterPatch(req: Request, model: Model) -> EventLoopFuture<Void>
    func setupPatchApiRoute(on: RoutesBuilder)
}

public extension PatchController {

    func accessPatch(req: Request) -> EventLoopFuture<Bool> {
        req.checkAccess(for: Model.permission(for: .patch))
    }

    func beforePatch(req: Request, model: Model) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }

    func patchApi(_ req: Request) throws -> EventLoopFuture<PatchApi.GetObject> {
        accessPatch(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            let api = PatchApi()
            return InputValidator(api.patchValidators())
                .validateResult(req)
                .throwingFlatMap { errors -> EventLoopFuture<PatchApi.GetObject> in
                    guard errors.isEmpty else {
                        return req.eventLoop.future(error: ValidationAbort(abort: Abort(.badRequest), details: errors))
                    }
                    return try findBy(identifier(req), on: req.db).throwingFlatMap { model in
                        let input = try req.content.decode(PatchApi.PatchObject.self)
                        return api.mapPatch(req, model: model as! PatchApi.Model, input: input)
                            .flatMap { beforePatch(req: req, model: model) }
                            .flatMap { model.update(on: req.db) }
                            .flatMap { afterPatch(req: req, model: model) }
                            .map { api.mapGet(model: model as! PatchApi.Model) }
                    }
                }
        }
    }

    func afterPatch(req: Request, model: Model) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }

    func setupPatchApiRoute(on builder: RoutesBuilder) {
        builder.patch(Model.idParamKeyPathComponent, use: patchApi)
    }
}
