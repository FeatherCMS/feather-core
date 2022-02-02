//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

extension Web.MenuItem.List: Content {}
extension Web.MenuItem.Detail: Content {}

struct WebMenuItemApiController: ApiController {
    typealias ApiModel = Web.MenuItem
    typealias DatabaseModel = WebMenuItemModel

    func getBaseRoutes(_ routes: RoutesBuilder) -> RoutesBuilder {
        routes
            .grouped(Web.pathKey.pathComponent)
            .grouped(Web.Menu.pathKey.pathComponent)
            .grouped(Web.Menu.pathIdComponent)
            .grouped(ApiModel.pathKey.pathComponent)
    }

    func listOutput(_ req: Request, _ models: [DatabaseModel]) async throws -> [Web.MenuItem.List] {
        models.map { model in
            .init(id: model.uuid, label: model.label, url: model.url, menuId: model.$menu.id)
        }
    }
    
    func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> Web.MenuItem.Detail {
        .init(id: model.uuid,
              label: model.label,
              url: model.url,
              isBlank: model.isBlank,
              priority: model.priority,
              permission: model.permission,
              menuId: model.$menu.id)
    }
    
    func createInput(_ req: Request, _ model: DatabaseModel, _ input: Web.MenuItem.Create) async throws {
        model.label = input.label
        model.url = input.url
        model.isBlank = input.isBlank
        model.priority = input.priority
        model.permission = input.permission
        model.$menu.id = input.menuId
    }
    
    func updateInput(_ req: Request, _ model: DatabaseModel, _ input: Web.MenuItem.Update) async throws {
        model.label = input.label
        model.url = input.url
        model.isBlank = input.isBlank
        model.priority = input.priority
        model.permission = input.permission
        model.$menu.id = input.menuId
    }
    
    func patchInput(_ req: Request, _ model: DatabaseModel, _ input: Web.MenuItem.Patch) async throws {
        model.label = input.label ?? model.label
        model.url = input.url ?? model.url
        model.isBlank = input.isBlank ?? model.isBlank
        model.priority = input.priority ?? model.priority
        model.permission = input.permission ?? model.permission
        model.$menu.id = input.menuId ?? model.$menu.id
    }
    
    @AsyncValidatorBuilder
    func validators(optional: Bool) -> [AsyncValidator] {
        KeyedContentValidator<String>.required("label", optional: optional)
        KeyedContentValidator<String>.required("url", optional: optional)
        KeyedContentValidator<UUID>.required("menuId", optional: optional)
    }
}
