//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 10..
//

public extension Request {

    /// Checks if the user has a given permission
    ///
    /// - Parameters:
    ///     - for: The permission object to check
    ///     - args: Additional arguments for the permission hook function
    ///
    /// - Returns: A bool value indicating if the user has the given permission
    ///
    func checkPermission(for permission: Permission, args: HookArguments = [:]) -> Bool {
        var permissionArgs = args
        permissionArgs.permission = permission
        let hooks: [Bool] = invokeAll(.permission, args: permissionArgs)
        return hooks.reduce(true) { $0 && $1  }
    }

    /// Checks if the user has a given access for a permission
    ///
    /// - Parameters:
    ///     - for: The permission object to check
    ///     - args: Additional arguments for the permission hook function
    ///
    /// - Returns: A bool value indicating if the user has the given access
    ///
    func checkAccess(for permission: Permission, args: HookArguments = [:]) -> EventLoopFuture<Bool> {
        var accessArgs = args
        accessArgs.permission = permission
        let namedHooks: [EventLoopFuture<Bool>] = invokeAll(permission.accessIdentifier, args: accessArgs)
        let accessHooks: [EventLoopFuture<Bool>] = invokeAll(.access, args: accessArgs)
        return eventLoop.mergeTrueFutures(namedHooks + accessHooks)
    }
}
