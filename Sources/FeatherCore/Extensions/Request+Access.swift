//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

public extension Request {

    func checkAccess(for permission: FeatherPermission, args: HookArguments = [:]) async throws -> Bool {
        var accessArgs = args
        accessArgs["permission"] = permission
        let namedHooks: [Bool] = try await invokeAllAsync(permission.accessKey, args: accessArgs)
        let accessHooks: [Bool] = try await invokeAllAsync("access", args: accessArgs)
        return (namedHooks + accessHooks).reduce(true) { $0 && $1  }
    }
}
