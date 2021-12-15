//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Vapor

public extension Request {
    
    func variable(_ key: String) -> String? {
        globals.get(key, scope: "variables")
    }
}

struct CommonVariablesMiddleware: AsyncMiddleware {

    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let variables = try await CommonVariableModel.query(on: req.db).all()
        for variable in variables {
            if let value = variable.value {
                req.globals.set(variable.key, value: value, scope: "variables")
            }
            else {
                req.globals.unset(variable.key, scope: "variables")
            }
        }
        return try await next.respond(to: req)
    }
}


