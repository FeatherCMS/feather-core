//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 22..
//

public extension FeatherHook {

    /// install
    static let installStep: FeatherHook = "install-step"
    static let installResponse: FeatherHook = "install-response"
    
    static let installModels: FeatherHook = "install-models"
    static let installPermissions: FeatherHook = "install-permissions"
    static let installVariables: FeatherHook = "install-variables"
    static let installPages: FeatherHook = "install-pages"
    static let installMainMenuItems: FeatherHook = "install-main-menu-items"

    /// routes
    static let routes: FeatherHook = "routes"
    static let webRoutes: FeatherHook = "web-routes"
    static let frontendRoutes: FeatherHook = "frontend-routes"
    static let adminRoutes: FeatherHook = "admin-routes"
    static let apiRoutes: FeatherHook = "api-routes"
    static let apiAdminRoutes: FeatherHook = "api-admin-routes"
    /// admin 
    static let adminMenu: FeatherHook = "admin-menu"
    static let adminWidget: FeatherHook = "admin-widget"
    /// acl
    static let permission: FeatherHook = "permission"
    static let access: FeatherHook = "access"
    /// middlewaress
    static let webMiddlewares: FeatherHook = "web-middlewares"
    static let frontendMiddlewares: FeatherHook = "frontend-middlewares"
    static let adminMiddlewares: FeatherHook = "admin-middlewares"
    static let apiMiddlewares: FeatherHook = "api-middlewares"
    /// content filters
    static let contentFilters: FeatherHook = "content-filters"
    /// response
    static let response: FeatherHook = "response"
    
    static let contentActionsTemplate: FeatherHook = "content-actions-template"

    // MARK: - template hooks

    static let webCss: FeatherHook = "web-css-template"
    static let webCssInline: FeatherHook = "web-css-inline-template"
    static let webJs: FeatherHook = "web-js-template"
    static let webJsInline: FeatherHook = "web-js-inline-template"

    static let frontendCss: FeatherHook = "frontend-css-template"
    static let frontendCssInline: FeatherHook = "frontend-css-inline-template"
    static let frontendJs: FeatherHook = "frontend-js-template"
    static let frontendJsInline: FeatherHook = "frontend-js-inline-template"
    
    static let adminCss: FeatherHook = "admin-css-template"
    static let adminCssInline: FeatherHook = "admin-css-inline-template"
    static let adminJs: FeatherHook = "admin-js-template"
    static let adminJsInline: FeatherHook = "admin-js-inline-template"
    
    static let installCss: FeatherHook = "install-css-template"
    static let installCssInline: FeatherHook = "install-css-inline-template"
    static let installJs: FeatherHook = "install-js-template"
    static let installJsInline: FeatherHook = "install-js-inline-template"
}

