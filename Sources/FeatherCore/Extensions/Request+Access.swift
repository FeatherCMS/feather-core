//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

public extension Request {

    func checkAccess(for permission: UserPermission, args: HookArguments = [:]) async throws -> Bool {
        var accessArgs = args
        accessArgs["permission"] = permission
        let namedHooks: [Bool] = try await invokeAll(permission.accessKey, args: accessArgs)
        let accessHooks: [Bool] = try await invokeAll("access", args: accessArgs)
        return (namedHooks + accessHooks).reduce(true) { $0 && $1  }
    }
}
