//
//  ListViewController.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 12. 04..
//



public protocol ListApiRepresentable: ModelApi {
    associatedtype ListObject: Content
    
    func mapList(model: Model) -> ListObject
}


public struct ListControllerContext: Codable {

    public let module: String
    public let model: String
    public let title: String

    public let searchable: Bool
    public let create: Bool
    public let view: Bool
    public let update: Bool
    public let delete: Bool
    
    public let allowedOrders: [String]
    public let defaultOrder: String?
    public let defaultSort: String
}

public protocol ListController: ModelController {
    
    associatedtype ListApi: ListApiRepresentable

    /// the name of the list view template
    var listView: String { get }
    
    /// url query parameter list order key
    var listOrderKey: String { get }
    
    /// url query parameter list sort key
    var listSortKey: String { get }
    
    /// url query parameter list search key
    var listSearchKey: String { get }
    
    /// url query parameter list limit key
    var listLimitKey: String { get }
    
    /// url query parameter list page key
    var listPageKey: String { get }
    
    /// default list limit
    var listDefaultLimit: Int { get }
    
    var listTitle: String { get }
    
    var listIsSearchable: Bool { get }
    
    /// check if there is access to list objects, if the future the server will respond with a forbidden status
    func accessList(req: Request) -> EventLoopFuture<Bool>
    
    /// builds the query in order to list objects in the admin interface
    func listQueryBuilder(req: Request, queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model>
    
    func listTable(_ models: [Model]) -> Table
    
    func listContext(req: Request) -> ListControllerContext
    
    /// renders the list view
    func listView(req: Request) throws -> EventLoopFuture<View>

    func listApi(_ req: Request) throws -> EventLoopFuture<PaginationContainer<ListApi.ListObject>>

    /// setup list related routes
    func setupListRoute(on: RoutesBuilder)
    
    func setupListApiRoute(on builder: RoutesBuilder)
    
}


public extension ListController {

    var listOrderKey: String { "order" }
    var listSortKey: String { "sort" }
    var listSearchKey: String { "search" }
    var listLimitKey: String { "limit" }
    var listPageKey: String { "page" }
    var listDefaultLimit: Int { 10 }
    
    var listView: String { "System/Admin/List" }

    var listTitle: String { Model.name.lowercased().capitalized }
    
    var listIsSearchable: Bool { true }
    
    func accessList(req: Request) -> EventLoopFuture<Bool> {
        req.checkAccess(for: Model.permission(for: .list))
    }
    
    func listQueryBuilder(req: Request, queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        queryBuilder
    }

    func listContext(req: Request) -> ListControllerContext {
        .init(module: Model.Module.name,
              model: Model.name,
              title: listTitle,
              searchable: listIsSearchable,
              create: req.checkPermission(for: Model.permission(for: .create)),
              view: req.checkPermission(for: Model.permission(for: .get)),
              update: req.checkPermission(for: Model.permission(for: .update)),
              delete: req.checkPermission(for: Model.permission(for: .delete)),
              allowedOrders: Model.allowedOrders().map(\.description),
              defaultOrder: Model.allowedOrders().first?.description,
              defaultSort: Model.defaultSort().rawValue)
    }

    func listView(req: Request) throws -> EventLoopFuture<View> {
        accessList(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            return ListLoader<Model>().paginate(req)
                .flatMap { pc in
                    return render(req: req, template: listView, context: [
                        "table": listTable(pc.items).encodeToTemplateData(),
                        "pages": pc.info.encodeToTemplateData(),
                        "list": listContext(req: req).encodeToTemplateData(),
                    ])
                }
        }
    }

    func listApi(_ req: Request) throws -> EventLoopFuture<PaginationContainer<ListApi.ListObject>> {
        accessList(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            #warning("llprops, key, order, sort, etc.")
            return ListLoader<Model>().paginate(req).map { pc -> PaginationContainer<ListApi.ListObject> in
                let api = ListApi()
                let items = pc.map { api.mapList(model: $0 as! ListApi.Model) }
                return items
            }
        }
    }
    
    func setupListRoute(on builder: RoutesBuilder) {
        builder.get(use: listView)
    }

    func setupListApiRoute(on builder: RoutesBuilder) {
        builder.get(use: listApi)
    }
}
