//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

public extension Request {

    func checkAccess(for permission: FeatherPermission, args: HookArguments = [:]) async -> Bool {
        var accessArgs = args
        accessArgs["permission"] = permission
        let namedHooks: [Bool] = await invokeAll(permission.accessIdentifier, args: accessArgs)
        let accessHooks: [Bool] = await invokeAll("access", args: accessArgs)
        return (namedHooks + accessHooks).reduce(true) { $0 && $1  }
    }
}
