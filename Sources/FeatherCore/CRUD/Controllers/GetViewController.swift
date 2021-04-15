//
//  GetViewController.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 12. 04..
//


public protocol GetApiRepresentable: ModelApi {
    associatedtype GetObject: Codable
    
    func getOutput(_ req: Request, model: Model) -> EventLoopFuture<GetObject>
}

extension GetApiRepresentable {

    func getOutput(_ req: Request, model: Model) -> EventLoopFuture<GetObject> {
        req.eventLoop.future(error: Abort(.noContent))
    }
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


public protocol GetViewController: IdentifiableController {

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

    /// setup get related route
    func setupGetRoute(on: RoutesBuilder)
}

public extension GetViewController {
    
    func accessGet(req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
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
    
    func apiGet(_ req: Request) throws -> EventLoopFuture<GetApi.GetObject> {
        accessGet(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            let id = try identifier(req)
            return findBy(id, on: req.db).flatMap { model in
                return GetApi().getOutput(req, model: model as! GetApi.Model)
            }
        }
    }
    
    func getResponse(req: Request, model: Model) -> EventLoopFuture<Response> {
        render(req: req, template: getView, context: [
            "detail": getContext(req: req, model: model).encodeToTemplateData()
        ]).encodeResponse(for: req)
    }
    
    func setupGetRoute(on builder: RoutesBuilder) {
        builder.get(idPathComponent, use: get)
        
//        builder.get(idPathComponent, use: get)
    }
}
