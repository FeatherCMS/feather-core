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

public struct DetailContext: Encodable {

    public struct Field: Encodable {

        public enum `Type`: String, Encodable {
            case text
            case image
        }

        public let type: Type
        public let label: String
        public let value: String
        
        public init(type: DetailContext.Field.`Type` = .text, label: String, value: String) {
            self.type = type
            self.label = label
            self.value = value
        }
    }

    public let model: ModelInfo
    public let fields: [Field]
    public var metadata: Metadata?
    public var nav: [Link]
    public var bc: [Link]

    public init(model: ModelInfo, fields: [DetailContext.Field], metadata: Metadata? = nil, nav: [Link] = [], bc: [Link] = []) {
        self.model = model
        self.fields = fields
        self.metadata = metadata
        self.nav = nav
        self.bc = bc
    }
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

    func detailFields(req: Request, model: Model) -> [DetailContext.Field]
    
    func getContext(req: Request, model: Model) -> DetailContext
    
    /// returns a response after the get request
    func getResponse(req: Request, model: Model) -> EventLoopFuture<Response>

    func getApi(_ req: Request) throws -> EventLoopFuture<GetApi.GetObject>

    /// setup get related route
    func setupGetRoute(on builder: RoutesBuilder)

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
        
    func getContext(req: Request, model: Model) -> DetailContext {
        .init(model: Model.info(req), fields: detailFields(req: req, model: model))
    }

    func getResponse(req: Request, model: Model) -> EventLoopFuture<Response> {
        req.view.render(getView, getContext(req: req, model: model)).encodeResponse(for: req)
    }
    
    func setupGetRoute(on builder: RoutesBuilder) {
        builder.get(Model.idParamKeyPathComponent, use: get)
    }
    
    func setupGetApiRoute(on builder: RoutesBuilder) {
        builder.get(Model.idParamKeyPathComponent, use: getApi)
    }
}

public extension GetController where Model: MetadataRepresentable {
    func getResponse(req: Request, model: Model) -> EventLoopFuture<Response> {
        Model.findMetadata(reference: model.id!, on: req.db).flatMap { metadata -> EventLoopFuture<Response> in
            var context = getContext(req: req, model: model)
            guard let metadata = metadata else {
                return req.view.render(getView, context).encodeResponse(for: req)
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
            return req.view.render(getView, context).encodeResponse(for: req)
        }
    }
}

public protocol PublicGetController: GetController {
    func getPublicApi(_ req: Request) throws -> EventLoopFuture<GetApi.GetObject>

    func setupGetPublicApiRoute(on builder: RoutesBuilder)
}

public extension PublicGetController {
    
    func getPublicApi(_ req: Request) throws -> EventLoopFuture<GetApi.GetObject> {
        let id = try identifier(req)
        return findBy(id, on: req.db)
            .map { model in
            GetApi().mapGet(model: model as! GetApi.Model)
        }
    }

    func setupGetPublicApiRoute(on builder: RoutesBuilder) {
        builder.get(Model.idParamKeyPathComponent, use: getPublicApi)
    }
}
