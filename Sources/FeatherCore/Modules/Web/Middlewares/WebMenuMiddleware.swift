//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

fileprivate let scope = "web.menus"

public extension Request {
    
    func menu(_ key: String) -> MenuContext? {
        globals.get(key, scope: scope)
    }
}

struct WebMenuMiddleware: AsyncMiddleware {

    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let menus = try await WebMenuModel.query(on: req.db).with(\.$items).all()
        for menu in menus {
            let items = menu.items
                .sorted { $0.priority > $1.priority }
                .map { LinkContext(label: $0.label,
                                   path: $0.url,
                                   absolute: true,
                                   isBlank: $0.isBlank,
                                   dropLast: 0,
                                   priority: $0.priority,
                                   permission: $0.permission,
                                   style: .default) }
            
            req.globals.set(menu.key, value: MenuContext(key: menu.key, name: menu.name, items: items), scope: scope)
        }
        return try await next.respond(to: req)
    }
}
