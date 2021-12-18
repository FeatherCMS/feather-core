//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Vapor

fileprivate let scope = "web.menus"

public extension Request {
    
    func menuItems(_ key: String) -> [LinkContext] {
        globals.get(key, scope: scope) ?? []
    }
}

struct WebMenuMiddleware: AsyncMiddleware {

    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let menus: [LinkContext] = try await req.invokeAllFlatAsync("web-menus")
        let items = menus.sorted { $0.priority > $1.priority }

        req.globals.set("main", value: items, scope: scope)
        
        return try await next.respond(to: req)
    }
}
