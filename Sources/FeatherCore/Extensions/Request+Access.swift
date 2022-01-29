//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

public extension Request {

    /// Check user access
    ///
    /// This method checks if the user has access using a given permission
    /// The appropriate access hook function will be called using the arguments
    ///
    /// If the user has access the function returns true, otherwise false
    ///
    /// - Parameters:
    ///   - permission: The permission used to check the corresponding access
    ///   - args: Additional hook function arguments that you might want to provide
    /// - Returns: True if the user has access, otherwise false.
    ///
    func checkAccess(for permission: FeatherPermission, args: HookArguments = [:]) async throws -> Bool {
        var accessArgs = args
        accessArgs["permission"] = permission
        let namedHooks: [Bool] = try await invokeAllAsync(permission.accessKey, args: accessArgs)
        let accessHooks: [Bool] = try await invokeAllAsync("access", args: accessArgs)
        return (namedHooks + accessHooks).reduce(true) { $0 && $1  }
    }
}
