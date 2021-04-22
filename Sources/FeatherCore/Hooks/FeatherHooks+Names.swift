//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 22..
//

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

