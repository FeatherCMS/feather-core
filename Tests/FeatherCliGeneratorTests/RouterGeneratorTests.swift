//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import XCTest
@testable import FeatherCliGenerator

final class RouterGeneratorTests: XCTestCase {

    func testGenerator() async throws {
        
        let descriptor = ModuleDescriptor(name: "User", models: [
            ModelDescriptor(name: "Account", properties: [])
        ])
        
        let result = RouterGenerator(descriptor).generate()
        let expectation = """
            struct UserRouter: FeatherRouter {

                let accountApiController = UserAccountApiController()
                let accountAdminController = UserAccountAdminController()

                func apiRoutesHook(args: HookArguments) {
                    accountApiController.setUpRoutes(args.routes)
                }

                func adminRoutesHook(args: HookArguments) {
                    accountAdminController.setUpRoutes(args.routes)

                    args.routes.get(User.pathKey.pathComponent) { req -> Response in
                        let template = AdminModulePageTemplate(.init(title: "User",
                                                                     tag: UserAdminWidgetTemplate().render(req)))
                        return req.templates.renderHtml(template)
                    }
                }
                
            }
            """

        XCTAssertEqual(expectation, result)
    }
}
