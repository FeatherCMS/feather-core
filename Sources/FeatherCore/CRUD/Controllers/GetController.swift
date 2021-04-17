//
//  GetViewController.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 12. 04..
//


public protocol GetApiRepresentable: ModelApi {
    associatedtype GetObject: Content
    
    func mapGet(model: Model) -> GetObject
}

public struct GetViewContext: Codable {

    public struct Field: Codable {
        public let label: String
        public let value: String
    }

    public let title: String
    public let key: String
    public let list: Link
    public let nav: [Link]
    public let fields: [Field]
}


public protocol GetController: IdentifiableController {

    associatedtype GetApi: GetApiRepresentable
    
    /// the name of the get view template
    var getView: String { get }

    /// check if there is access to get tehe object, if the future the server will respond with a forbidden status
    func accessGet(req: Request) -> EventLoopFuture<Bool>
    
    /// builds the query in order to get the object in the admin interface
    func beforeGet(req: Request, model: Model) -> EventLoopFuture<Model>
    
    /// renders the get view
    func get(req: Request) throws -> EventLoopFuture<Response>

    func getContext(req: Request, model: Model) -> GetViewContext
    
    /// returns a response after the get request
    func getResponse(req: Request, model: Model) -> EventLoopFuture<Response>

    func getApi(_ req: Request) throws -> EventLoopFuture<GetApi.GetObject>

    /// setup get related route
    func setupGetRoute(on: RoutesBuilder)

    func setupGetApiRoute(on builder: RoutesBuilder)
}

public extension GetController {
    
    var getView: String { "System/Admin/Detail" }

    func accessGet(req: Request) -> EventLoopFuture<Bool> {
        req.checkAccess(for: Model.permission(for: .get))
    }

    func beforeGet(req: Request, model: Model) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }

    func get(req: Request) throws -> EventLoopFuture<Response> {
        accessGet(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            let id = try identifier(req)
            return findBy(id, on: req.db)
                .flatMap { beforeGet(req: req, model: $0) }
                .flatMap { getResponse(req: req, model: $0) }
        }
    }
    
    func getApi(_ req: Request) throws -> EventLoopFuture<GetApi.GetObject> {
        accessGet(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            let id = try identifier(req)
            return findBy(id, on: req.db).map { model in
                GetApi().mapGet(model: model as! GetApi.Model)
            }
        }
    }
    
    func getResponse(req: Request, model: Model) -> EventLoopFuture<Response> {
        req.view.render(getView, ["detail": getContext(req: req, model: model)])
            .encodeResponse(for: req)
    }
    
    func setupGetRoute(on builder: RoutesBuilder) {
        builder.get(idPathComponent, use: get)
    }
    
    func setupGetApiRoute(on builder: RoutesBuilder) {
        builder.get(idPathComponent, use: getApi)
    }
}
