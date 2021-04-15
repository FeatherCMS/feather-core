//
//  ListViewController.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 12. 04..
//



public protocol ListApiRepresentable: ModelApi {
    associatedtype ListObject: Codable
    
    func listOutput(_ req: Request, model: Model) -> EventLoopFuture<ListObject>
}

extension ListApiRepresentable {

    func listOutput(_ req: Request, model: Model) -> EventLoopFuture<ListObject> {
        req.eventLoop.future(error: Abort(.noContent))
    }
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

public protocol ListViewController: ViewController {
    
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


    /// setup list related routes
    func setupListRoute(on: RoutesBuilder)
    
}


public extension ListViewController {

    var listOrderKey: String { "order" }
    var listSortKey: String { "sort" }
    var listSearchKey: String { "search" }
    var listLimitKey: String { "limit" }
    var listPageKey: String { "page" }
    var listDefaultLimit: Int { 10 }

    var listTitle: String { Model.name.lowercased().capitalized }
    
    var listIsSearchable: Bool { true }
    
    func accessList(req: Request) -> EventLoopFuture<Bool> {
        let hasPermission = req.checkPermission(for: Model.permission(for: .list))
        return req.eventLoop.future(hasPermission)
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
              view: req.checkPermission(for: Model.permission(for: .create)),
              update: req.checkPermission(for: Model.permission(for: .create)),
              delete: req.checkPermission(for: Model.permission(for: .create)),
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

//    func apiList(_ req: Request) throws -> EventLoopFuture<Page<Model.ListItem>> {
//        accessList(req: req).throwingFlatMap { hasAccess in
//            guard hasAccess else {
//                return req.eventLoop.future(error: Abort(.forbidden))
//            }
//            return Model
//                .query(on: req.db)
//                .paginate(for: req)
//                .map { $0.map(\.listContent) }
//        }
//    }
    
    func setupListRoute(on builder: RoutesBuilder) {
        builder.get(use: listView)
        
//        builder.get(use: list)
    }
}
