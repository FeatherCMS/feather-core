//
//  ListViewController+Public.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

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
                        "pages": pc.info.templateData,
                        "list": listContext(req: req).encodeToTemplateData(),
                    ])
                }
        }
    }

    func setupListRoute(on builder: RoutesBuilder) {
        builder.get(use: listView)
    }
}
