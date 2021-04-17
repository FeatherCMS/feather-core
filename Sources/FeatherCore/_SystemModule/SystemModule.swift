//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 09..
//


final class SystemModule: FeatherModule {

    static var name: String = "system"

    static var bundleUrl: URL? {
        Bundle.module.resourceURL?.appendingPathComponent("Bundle")
    }

    func boot(_ app: Application) throws {
        /// database
        app.databases.middleware.use(SystemUserModelSafeEmailMiddleware())
        app.databases.middleware.use(MetadataModelMiddleware<SystemPageModel>())
        app.migrations.add(SystemMigration_v1())
        /// middlewares
        app.middleware.use(SystemTemplateScopeMiddleware())
        app.middleware.use(SystemSafePathMiddleware())
        app.middleware.use(SystemInstallGuardMiddleware())
        app.middleware.use(SystemUserSessionAuthenticator())
        /// install
        app.hooks.register("install-models", use: installModelsHook)
        app.hooks.register("install-permissions", use: installPermissionsHook)
        app.hooks.register("install-variables", use: installVariablesHook)
        /// acl
        app.hooks.register("permission", use: permissionHook)
        app.hooks.register("access", use: accessHook)
        /// auth
        app.hooks.register("admin-auth-middlewares", use: adminAuthMiddlewaresHook)
        app.hooks.register("api-auth-middlewares", use: apiAuthMiddlewaresHook)
        //app.hooks.register("system-variables-list-access", use: systemVariablesAccessHook)
        /// admin menus
        app.hooks.register("admin-menus", use: adminMenusHook)
        /// routes
        let router = SystemRouter()
        try router.boot(routes: app.routes)
        app.hooks.register("routes", use: router.routesHook)
        app.hooks.register("admin-routes", use: router.adminRoutesHook)
        app.hooks.register("public-api-routes", use: router.publicApiRoutesHook)
        app.hooks.register("api-routes", use: router.apiRoutesHook)
        /// pages
        app.hooks.register("response", use: responseHook)
        app.hooks.register("home-page", use: homePageHook)
    }
  
    // MARK: - hooks
    
    func responseHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args.req

        /// if system is not installed yet, perform install process
        guard Application.Config.installed else {
            return performInstall(req: req).encodeOptionalResponse(for: req)
        }
        
        return SystemPageModel
            .queryJoinVisibleMetadata(path: req.url.path, on: req.db)
            .first()
            .flatMap { page -> EventLoopFuture<Response?> in
                guard let page = page else {
                    return req.eventLoop.future(nil)
                }
                /// if the content of a page has a page tag, then we respond with the corresponding page hook function
                let content = page.content.trimmingCharacters(in: .whitespacesAndNewlines)
                if content.hasPrefix("["), content.hasSuffix("-page]") {
                    let name = String(content.dropFirst().dropLast())
                    let args: HookArguments = ["page-metadata": page.joinedMetadata as Any]
                    if let future: EventLoopFuture<Response?> = req.invoke(name, args: args) {
                        return future
                    }
                }
                /// render the page with the filtered content
                return page.filter(content, req: req).flatMap {
                    var ctx = page.encodeToTemplateData().dictionary!
                    ctx["content"] = .string($0)
                    return req.tau.render(template: "System/Page", context: .init(ctx)).encodeOptionalResponse(for: req)
                }
            }
    }
    
    /// renders the [home-page] content
    func homePageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args.req
        
        let metadata = args["page-metadata"] as! Metadata

        return req.view.render("System/Home", ["metadata": metadata]).encodeOptionalResponse(for: req)
    }
    
    // MARK: - perform install steps
    
    /// @TODO: we should add a steppable hook system for adding custom install steps...
    func performInstall(req: Request) -> EventLoopFuture<View> {
        /// if the system path equals install, we render the start install screen
        guard req.url.path == "/install/" else {
            return req.view.render("System/Install/Start")
        }
    
        /// upload bundled images using the file storage if there are some files under the Install folder inside the module bundle
        var fileUploadFutures: [EventLoopFuture<Void>] = []
        for module in req.application.feather.modules {
            guard let moduleBundle = module.bundleUrl else {
                continue
            }
            let name = module.name.lowercased()
            let sourcePath = moduleBundle.appendingPathComponent("Install").path
            let sourceUrl = URL(fileURLWithPath: sourcePath)
            let keys: [URLResourceKey] = [.isDirectoryKey]
            
            let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]
 
            let urls = FileManager.default.enumerator(at: sourceUrl, includingPropertiesForKeys: keys, options: options)!
            for case let fileUrl as URL in urls {
                let resourceValues = try? fileUrl.resourceValues(forKeys: Set(keys))
                if resourceValues?.isDirectory ?? true {
                    continue
                }
                let relativePath = String(fileUrl.path.dropFirst(sourceUrl.path.count + 1))
                let relativeUrl = URL(fileURLWithPath: relativePath, relativeTo: sourceUrl)
                let future = req.fileio.collectFile(at: relativeUrl.path).flatMap { byteBuffer -> EventLoopFuture<Void> in
                    guard let data = byteBuffer.getData(at: 0, length: byteBuffer.readableBytes) else {
                        return req.eventLoop.future()
                    }
                    return req.fs.upload(key: name + "/" + relativeUrl.relativePath, data: data).map { _ in }
                }
                fileUploadFutures.append(future)
            }
        }

        /// we request the install futures for the database models & execute them together with the file upload futures in parallel
        let modelInstallFutures: [EventLoopFuture<Void>] = req.invokeAll("install-models")
        return req.eventLoop.flatten(modelInstallFutures + fileUploadFutures)
            .map { Application.Config.installed = true }
            .flatMap { req.view.render("System/Install/Finish") }
            .flatMapError { req.view.render("System/Install/Error", ["error": $0.localizedDescription]) }
            
    }

    func adminAuthMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            SystemUserModel.redirectMiddleware(path: "/login/?redirect=/admin/"),
            AccessGuardMiddleware(.init(namespace: "admin", context: "module", action: .custom("access")))
        ]
    }
    
    func apiAuthMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            SystemTokenModel.authenticator(),
            SystemUserModel.guardMiddleware()
        ]
    }
    
    func adminMenusHook(args: HookArguments) -> [SystemMenu] {
        [
            .init(key: "system",
                  name: "System",
                  icon: "system",
                  permission: nil,
                  items: [
                    .init(label: "Dashboard",
                          url: "/admin/dashboard/",
                          permission: nil),
                    .init(label: "Settings",
                          url: "/admin/settings/",
                          permission: nil),
                  ]),
            .init(key: "web", name: "Web", icon: "web",
                  permission: nil,
                  items: [
                    .init(label: "Pages",
                          url: "/admin/system/pages/",
                          permission: nil),
                    .init(label: "Menus",
                          url: "/admin/system/menus/",
                          permission: nil),
                    .init(label: "Variables",
                          url: "/admin/system/variables/",
                          permission: nil),
                    .init(label: "Metadatas",
                          url: "/admin/system/metadatas/",
                          permission: nil),
                  ]),
            .init(key: "user", name: "User", icon: "user",
                  permission: nil,
                  items: [
                    .init(label: "Users",
                          url: "/admin/system/users/",
                          permission: nil),
                    .init(label: "Permissions",
                          url: "/admin/system/permissions/",
                          permission: nil),
                    .init(label: "Roles",
                          url: "/admin/system/roles/",
                          permission: nil),
                  ]),
        ]
    }

    func permissionHook(args: HookArguments) -> Bool {
        let permission = args["permission"] as! Permission
        
        guard let user = args.req.auth.get(SystemUserModel.self) else {
            return false
        }
        if user.root {
            return true
        }
        return user.permissions.contains(permission.identifier)
    }
    
    /// by default return the permission as an access...
    func accessHook(args: HookArguments) -> EventLoopFuture<Bool> {
        args.req.eventLoop.future(permissionHook(args: args))
    }

//    func systemVariablesAccessHook(args: HookArguments) -> EventLoopFuture<Bool> {
//        let req = args["req"] as! Request
//        return req.eventLoop.future(true)
//    }
    
/*
     Translation experiment:

     #("foo".t())
     
     app.hooks.register("translation", use: test)

     func test(args: HookArguments) -> [String: String] {
        [
            "foo": "bar"
        ]
     }
 */
        
    
}
