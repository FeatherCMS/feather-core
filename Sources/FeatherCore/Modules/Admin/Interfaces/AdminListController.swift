//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

public protocol AdminListController: ListController {
    func listView(_ req: Request) async throws -> Response
    func listTemplate(_ req: Request, _ list: ListContainer<DatabaseModel>) -> TemplateRepresentable
    
    func listColumns() -> [ColumnContext]
    func listCells(for model: DatabaseModel) -> [CellContext]
    func listContext(_ req: Request, _ list: ListContainer<DatabaseModel>) -> AdminListPageContext
    func listNavigation(_ req: Request) -> [LinkContext]
    func listBreadcrumbs(_ req: Request) -> [LinkContext]
    
    func setupListRoutes(_ routes: RoutesBuilder)
}


public extension AdminListController {
    func listView(_ req: Request) async throws -> Response {
        let hasAccess = try await listAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let list = try await list(req)
        return req.templates.renderHtml(listTemplate(req, list))
    }
    
    func listTemplate(_ req: Request, _ list: ListContainer<DatabaseModel>) -> TemplateRepresentable {
        AdminListPageTemplate(listContext(req, list))
    }
    
    func listContext(_ req: Request, _ list: ListContainer<DatabaseModel>) -> AdminListPageContext {
        let rows = list.items.map {
            RowContext(id: $0.uuid.string, cells: listCells(for: $0))
        }
        
        let table = TableContext(id: [DatabaseModel.Module.featherIdentifier, DatabaseModel.featherIdentifier, "table"].joined(separator: "-"),
                                 columns: listColumns(),
                                 rows: rows,
                                 actions: [
                                    LinkContext(label: "Update",
                                                path: "update",
                                                permission: ApiModel.permission(for: .update).key),
                                    LinkContext(label: "Delete",
                                                path: "delete/?redirect=" + req.url.path + "&cancel=" + req.url.path,
                                                permission: ApiModel.permission(for: .delete).key),
                                 ],
                                 options: .init(allowedOrders: listConfig.allowedOrders.map(\.description),
                                                defaultSort: listConfig.defaultSort))

        return .init(title: Self.modelName.plural.uppercasedFirst,
                     isSearchable: listConfig.isSearchable,
                     table: table,
                     pagination: list.info,
                     navigation: listNavigation(req),
                     breadcrumbs: listBreadcrumbs(req))
    }
    
    func listNavigation(_ req: Request) -> [LinkContext] {
        [
            LinkContext(label: "Create",
                        path: "create",
                        permission: ApiModel.permission(for: .create).key)
        ]
    }
    
    func listBreadcrumbs(_ req: Request) -> [LinkContext] {
        [
            LinkContext(label: DatabaseModel.Module.featherIdentifier.uppercasedFirst,
                        dropLast: 1,
                        permission: nil), //Model.Module.permission.key),
        ]
    }
    
    func setupListRoutes(_ routes: RoutesBuilder) {
        let baseRoutes = getBaseRoutes(routes)
        
        baseRoutes.get(use: listView)
    }
}
