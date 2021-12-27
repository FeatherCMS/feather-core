//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

fileprivate let scope = "common.variables"

public extension Request {
    
    func variable(_ key: String) -> String? {
        globals.get(key, scope: scope)
    }
    
    func checkVariable(_ key: String) -> Bool {
        let rawValue = variable(key) ?? "false"
        return Bool(rawValue) ?? false
    }
    
    func setVariable(_ key: String, value: String?) async throws {
        try await CommonVariableModel.query(on: db)
            .filter(\.$key == key)
            .set(\.$value, to: value)
            .update()
    }
}

struct CommonVariablesMiddleware: AsyncMiddleware {

    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let variables = try await CommonVariableModel.query(on: req.db).all()
        for variable in variables {
            if let value = variable.value {
                req.globals.set(variable.key, value: value, scope: scope)
            }
            else {
                req.globals.unset(variable.key, scope: scope)
            }
        }
        return try await next.respond(to: req)
    }
}


