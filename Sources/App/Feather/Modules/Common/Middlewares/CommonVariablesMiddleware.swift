//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Vapor

private extension Application {
    
    struct VariablesStorageKey: StorageKey {
        typealias Value = [String: String]
    }

    var variables: [String: String] {
        get {
            self.storage[VariablesStorageKey.self] ?? [:]
        }
        set {
            self.storage[VariablesStorageKey.self] = newValue
        }
    }
}

public extension Request {
    
    func variable(_ key: String) -> String? {
        application.variables[key]
    }
}

struct CommonVariablesMiddleware: AsyncMiddleware {

    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let variables = try await CommonVariableModel.query(on: req.db).all()
        var tmp: [String: String] = [:]
        for variable in variables {
            /// NOTE: this might be wrong and we don't have to check value existance
            if let value = variable.value {
                tmp[variable.key] = value
            }
        }
        req.application.variables = tmp
        return try await next.respond(to: req)
    }
}


