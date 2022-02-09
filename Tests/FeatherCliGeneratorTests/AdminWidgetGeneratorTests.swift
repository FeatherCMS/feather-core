//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 09..
//

import XCTest
@testable import FeatherCliGenerator

final class AdminWidgetGeneratorTests: XCTestCase {

    func testGenerator() async throws {
        let descriptor = ModuleDescriptor(name: "User", models: [
            ModelDescriptor(name: "Account", properties: []),
            ModelDescriptor(name: "Role", properties: []),
            ModelDescriptor(name: "Permission", properties: []),
        ])
        
        let result = AdminWidgetGenerator(descriptor).generate()
        let expectation = """
            import SwiftHtml
            import FeatherIcons

            struct UserAdminWidgetTemplate: TemplateRepresentable {
                
                @TagBuilder
                func render(_ req: Request) -> Tag {
                    Svg.feather
                    H2("User")
                    Ul {
                        if req.checkPermission(User.Account.permission(for: .list)) {
                            Li {
                                A("Accounts")
                                    .href("/admin/user/accounts/")
                            }
                        }
                        if req.checkPermission(User.Role.permission(for: .list)) {
                            Li {
                                A("Roles")
                                    .href("/admin/user/roles/")
                            }
                        }
                        if req.checkPermission(User.Permission.permission(for: .list)) {
                            Li {
                                A("Permissions")
                                    .href("/admin/user/permissions/")
                            }
                        }
                    }
                }
            }
            """

        XCTAssertEqual(expectation, result)
    }
}
