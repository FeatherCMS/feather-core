//
//  RedirectModule.swift
//
//
//  Created by Steve Tibbett on 2021-12-19
//

import Vapor
import Fluent

public extension HookName {
//    static let permission: HookName = "redirect"
}

/**
 Allows configuring of redirects via RedirectRule instances.  Redirects turn a
 GET request to a given source path into a redirect to a destination URL,
 either relative or absolute.  Redirect type is specified by statusCode (301,
 303, or 308).
 */
struct RedirectModule: FeatherModule {

    let router = RedirectRouter()
    
    func boot(_ app: Application) throws {
        app.migrations.add(RedirectMigrations.v1())

        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.registerAsync(.adminWidgets, use: adminWidgetsHook)
        app.hooks.registerAsync(.response, use: responseHook)
    }

    func adminWidgetsHook(args: HookArguments) async throws -> [TemplateRepresentable] {
        return [RedirectAdminWidgetTemplate(args.req)]
    }
    
    /**
     Apply redirect rules to incoming requests.
     */
    func responseHook(args: HookArguments) async throws -> Response? {
        let req = args.req
        guard let rule = try await RedirectRuleModel
                .query(on: req.db)
                .filter(\.$source == req.url.path)
                .first() else {
                    return nil
                }
        
        let type: RedirectType
        switch UInt(rule.statusCode) {
        case HTTPResponseStatus.movedPermanently.code:
            type = .permanent
        case HTTPResponseStatus.temporaryRedirect.code:
            type = .temporary
        case HTTPResponseStatus.seeOther.code:
            fallthrough
        default:
            type = .normal
        }
        
        return req.redirect(to: rule.destination, type: type)
    }

}
