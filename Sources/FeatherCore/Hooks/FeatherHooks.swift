//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 22..
//

public enum FeatherHook {
    case name(String)
}

extension FeatherHook: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .name(value)
    }
}

extension FeatherHook: CustomStringConvertible {
    public var description: String {
        switch self {
        case .name(let name):
            return name
        }
    }
}

public extension FeatherHook {

    /// install
    static let installModels: FeatherHook = "install-models"
    static let installPermissions: FeatherHook = "install-permissions"
    static let installVariables: FeatherHook = "install-variables"
    static let installPages: FeatherHook = "install-pages"
    static let installMainMenuItems: FeatherHook = "install-main-menu-items"

    /// routes
    static let routes: FeatherHook = "routes"
    static let adminRoutes: FeatherHook = "admin-routes"
    static let apiRoutes: FeatherHook = "api-routes"
    static let apiAdminRoutes: FeatherHook = "api-admin-routes"
    /// admin menu
    static let adminMenu: FeatherHook = "admin-menu"
    /// acl
    static let permission: FeatherHook = "permission"
    static let access: FeatherHook = "access"
    /// middlewaress
    static let webMiddlewares: FeatherHook = "web-middlewares"
    static let apiMiddlewares: FeatherHook = "api-middlewares"
    static let adminMiddlewares: FeatherHook = "admin-middlewares"
    /// content filters
    static let contentFilters: FeatherHook = "content-filters"
    /// response
    static let response: FeatherHook = "response"
}

public extension HookStorage {
    
    func register<ReturnType>(_ hook: FeatherHook, use block: @escaping HookFunctionSignature<ReturnType>) {
        register(hook.description, use: block)
    }
}

public extension Request {

    func invoke<ReturnType>(_ hook: FeatherHook, args: HookArguments = [:]) -> ReturnType? {
        invoke(hook.description, args: args)
    }

    /// invokes all the available hook functions with a given name and inserts the app & req pointers as arguments
    func invokeAll<ReturnType>(_ hook: FeatherHook, args: HookArguments = [:]) -> [ReturnType] {
        invokeAll(hook.description, args: args)
    }
}

public extension Application {
    
    func invoke<ReturnType>(_ hook: FeatherHook, args: HookArguments = [:]) -> ReturnType? {
        invoke(hook.description, args: args)
    }

    /// invokes all the available hook functions with a given name and inserts the app pointer as argument
    func invokeAll<ReturnType>(_ hook: FeatherHook, args: HookArguments = [:]) -> [ReturnType] {
        invokeAll(hook.description, args: args)
    }
}

