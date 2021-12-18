//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor
import Fluent
import FeatherCore

public extension HookName {

//    static let permission: HookName = "permission"
}

struct BlogModule: FeatherModule {

    let router = BlogRouter()
    
    func boot(_ app: Application) throws {
        app.migrations.add(BlogMigrations.v1())
        
        app.databases.middleware.use(MetadataModelMiddleware<BlogPostModel>())
        app.databases.middleware.use(MetadataModelMiddleware<BlogCategoryModel>())
        app.databases.middleware.use(MetadataModelMiddleware<BlogAuthorModel>())
        
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        
        app.hooks.register(.adminWidgets, use: adminWidgetsHook)
        app.hooks.register(.response, use: responseHook)

    }
    
    func adminWidgetsHook(args: HookArguments) async -> [TemplateRepresentable] {
//        if args.req.checkPermission(BlogModule.permission) {
            return [BlogAdminWidgetTemplate(args.req)]
//        }
//        return []
    }
    
    func responseHook(args: HookArguments) async throws -> Response? {
        let category = try await BlogCategoryApi().findDetailBy(path: args.req.url.path, args.req)
        guard let category = category else {
            return nil
        }
        let template = BlogCategoryPageTemplate(args.req, context: .init(category: category))
        return args.req.html.render(template)
    }
}
