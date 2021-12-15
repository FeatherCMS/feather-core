//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Vapor

private extension Application {
    
    struct MenuStorageKey: StorageKey {
        typealias Value = [WebMenuContext]
    }
    
    var menus: [WebMenuContext] {
        get {
            self.storage[MenuStorageKey.self] ?? []
        }
        set {
            self.storage[MenuStorageKey.self] = newValue
        }
    }
    
    struct AStorageKey: StorageKey {
        typealias Value = Bool
    }
    
    var a: Bool {
        get {
            self.storage[AStorageKey.self] ?? false
        }
        set {
            self.storage[AStorageKey.self] = newValue
        }
    }
}

public extension Request {
    
    func menuItems(_ id: String) -> [LinkContext] {
        application.menus.filter { $0.key == id }.first?.children ?? []
    }
}

struct WebMenuMiddleware: AsyncMiddleware {

    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard req.application.menus.isEmpty else {
            return try await next.respond(to: req)
        }
        let menus: [LinkContext] = await req.invokeAllFlat("web-menus")
        let items = menus.sorted { $0.priority > $1.priority }

        req.application.menus = [
            .init(key: "main", children: items)
        ]
        return try await next.respond(to: req)
    }
}
