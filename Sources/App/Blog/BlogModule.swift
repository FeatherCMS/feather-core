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
        
        app.databases.middleware.use(MetadataModelMiddleware<BlogCategoryModel>())
        
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
    
    func responseHook(args: HookArguments) async -> Response? {        
        let category = try! await BlogCategoryModel.queryJoinVisibleMetadataFilterBy(path: args.req.url.path, on: args.req.db)
            .first()
        guard let category = category else {
            return nil
        }
        let posts = try! await category.$posts.query(on: args.req.db)
//            .joinPublicMetadata()
            .all()

//        args.req.fs.resolve(key: category.imageKey)
//
//

        
        let template = BlogCategoryPageTemplate.init(args.req, context: .init(category: BlogCategoryApi().mapDetail(model: category), posts: []))
        return args.req.html.render(template)

    }
}
