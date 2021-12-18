//
//  Request+Permission.swift
//  Feather
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

public extension Request {

    /// Check user permission
    ///
    /// This method checks if the user has a given permission
    /// If the permission name is nil, the method returns `true`, if the permission name is invalid the method returns `false`.
    ///
    /// If the name was valid,  the method returns if the user has the permission or not.
    ///
    /// - Parameters:
    ///   - name: The full name of the permission, if `nil` the method returns `true`
    ///   - args: Additional hook function arguments that you might want to provide
    /// - Returns: True if `the` name is `nil` or the user has the given permission, otherwise `false`
    ///
    func checkPermission(_ key: String?, args: HookArguments = [:]) -> Bool {
        guard let key = key else {
            return true
        }
        return checkPermission(UserPermission(key), args: args)
    }

    /// Check user permission
    ///
    /// This method checks if the user has a given permission
    ///
    /// - Parameters:
    ///   - permission: The permission object to check
    ///   - args: Additional hook function arguments that you might want to provide
    /// - Returns: True if the user has the given permission, otherwise `false`
    ///
    func checkPermission(_ permission: UserPermission, args: HookArguments = [:]) -> Bool {
        var arguments = args
        arguments.permission = permission
        let hooks: [Bool] = invokeAll(.permission, args: arguments)
        return hooks.reduce(true) { $0 && $1  }
    }
}
