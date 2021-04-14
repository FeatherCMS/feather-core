//
//  ListViewController.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 12. 04..
//

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
