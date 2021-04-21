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


public struct ListContext: Encodable {

    public let model: ModelInfo
    public let table: Table
    public let pages: Pagination
    
    public init(info: ModelInfo, table: Table, pages: Pagination) {
        self.model = info
        self.table = table
        self.pages = pages
    }
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
    
    /// default page number to show
    var listDefaultPage: Int { get }
    
    /// default list limit
    var listDefaultLimit: Int { get }
    
    var listTitle: String { get }
    
    var listIsSearchable: Bool { get }
    
    /// check if there is access to list objects, if the future the server will respond with a forbidden status
    func accessList(req: Request) -> EventLoopFuture<Bool>
    
    /// builds the query in order to list objects in the admin interface
    func beforeListQuery(queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model>
    
    func listTable(_ models: [Model]) -> Table
    
    func listContext(req: Request, table: Table, pages: Pagination) -> ListContext
    
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
    var listDefaultPage: Int { 1 }
    
    var listView: String { "System/Admin/List" }

    var listTitle: String { Model.name.plural.lowercased().capitalized }
    
    var listIsSearchable: Bool { true }
    
    var listLoader: ListLoader<Model> {
        ListLoader<Model>(sortKey: listSortKey,
                          orderKey: listOrderKey,
                          searchKey: listSearchKey,
                          limitKey: listLimitKey,
                          limit: listDefaultLimit,
                          pageKey: listPageKey,
                          page: listDefaultPage,
                          beforeQuery: beforeListQuery)
    }
    
    func accessList(req: Request) -> EventLoopFuture<Bool> {
        req.checkAccess(for: Model.permission(for: .list))
    }
    
    func beforeListQuery(queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        queryBuilder
    }

    func listContext(req: Request, table: Table, pages: Pagination) -> ListContext {
        .init(info: Model.info(req), table: table, pages: pages)
    }

    func listView(req: Request) throws -> EventLoopFuture<View> {
        accessList(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            return listLoader.paginate(req)
                .flatMap { req.view.render(listView, listContext(req: req, table: listTable($0.items), pages: $0.info)) }
        }
    }

    func listApi(_ req: Request) throws -> EventLoopFuture<PaginationContainer<ListApi.ListObject>> {
        accessList(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            return listLoader.paginate(req).map { pc -> PaginationContainer<ListApi.ListObject> in
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
