//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

import Fluent

fileprivate let scope = "system.variables"

public extension Request {
    
    func variable(_ key: String) -> String? {
        globals.get(key, scope: scope)
    }
    
    func checkVariable(_ key: String) -> Bool {
        let rawValue = variable(key) ?? "false"
        return Bool(rawValue) ?? false
    }
    
    func setVariable(_ key: String, value: String?) async throws {
//        var arguments = HookArguments()
//        arguments["key"] = key
//        arguments["value"] = key
//        let _: [Void] = try await invokeAllFlatAsync(.setVariable, args: arguments)
        try await SystemVariableModel.query(on: db)
            .filter(\.$key == key)
            .set(\.$value, to: value)
            .update()
    }
}

struct SystemVariablesMiddleware: AsyncMiddleware {

    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
//        try await req.application.myConfiguration.loadVariables(req)
//        let _: [Void] = try await req.invokeAllFlatAsync(.loadVariables)
        let variables = try await SystemVariableModel.query(on: req.db).all()
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

//
//actor GlobalVariableStorage {
//    private var isLoaded: Bool
//
//    init() {
//        self.isLoaded = false
//    }
//
//    func loadVariables(_ req: Request) async throws {
//        guard !isLoaded else {
//            print("no need to load")
//            return
//        }
//        print("load")
//        let variables = try await SystemVariableModel.query(on: req.db).all()
//        for variable in variables {
//            if let value = variable.value {
//                req.globals.set(variable.key, value: value, scope: scope)
//            }
//            else {
//                req.globals.unset(variable.key, scope: scope)
//            }
//        }
//        isLoaded = true
//    }
//
//}
//
//struct GlobalVariableStorageKey: StorageKey {
//    typealias Value = GlobalVariableStorage
//}
//
//extension Application {
//
//    var myConfiguration: GlobalVariableStorage {
//        get {
//            if let existing = storage[GlobalVariableStorageKey.self] {
//                return existing
//            }
//            let new = GlobalVariableStorage()
//            storage[GlobalVariableStorageKey.self] = new
//            return new
//        }
//        set {
//            self.storage[GlobalVariableStorageKey.self] = newValue
//        }
//    }
//}


