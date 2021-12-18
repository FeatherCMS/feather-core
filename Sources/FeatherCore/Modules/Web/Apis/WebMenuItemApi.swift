//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor

extension WebMenuItem.List: Content {}
extension WebMenuItem.Detail: Content {}
extension WebMenuItem.Create: Content {}
extension WebMenuItem.Update: Content {}
extension WebMenuItem.Patch: Content {}

struct WebMenuItemApi: FeatherApi {
    typealias Model = WebMenuItemModel

    func mapList(_ req: Request, model: Model) async throws -> WebMenuItem.List {
        .init(id: model.uuid, label: model.label, url: model.url, menuId: model.$menu.id)
    }
    
    func mapDetail(_ req: Request, model: Model) async throws -> WebMenuItem.Detail {
        .init(id: model.uuid,
              label: model.label,
              url: model.url,
              icon: model.icon,
              isBlank: model.isBlank,
              priority: model.priority,
              permission: model.permission,
              menuId: model.$menu.id)
    }
    
    func mapCreate(_ req: Request, model: Model, input: WebMenuItem.Create) async throws {
        model.label = input.label
        model.url = input.url
        model.icon = input.icon
        model.isBlank = input.isBlank
        model.priority = input.priority
        model.permission = input.permission
        model.$menu.id = input.menuId
    }
    
    func mapUpdate(_ req: Request, model: Model, input: WebMenuItem.Update) async throws {
        model.label = input.label
        model.url = input.url
        model.icon = input.icon
        model.isBlank = input.isBlank
        model.priority = input.priority
        model.permission = input.permission
        model.$menu.id = input.menuId
    }
    
    func mapPatch(_ req: Request, model: Model, input: WebMenuItem.Patch) async throws {
        model.label = input.label ?? model.label
        model.url = input.url ?? model.url
        model.icon = input.icon ?? model.icon
        model.isBlank = input.isBlank ?? model.isBlank
        model.priority = input.priority ?? model.priority
        model.permission = input.permission ?? model.permission
        model.$menu.id = input.menuId ?? model.$menu.id
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        []
    }
}
