//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import XCTest
@testable import FeatherCliGenerator

final class ModuleGeneratorTests: XCTestCase {

    func testGenerator() async throws {
        
        let descriptor = ModuleDescriptor(name: "User", author: "", date: .init(), models: [
            ModelDescriptor(name: "Account", properties: [
                .init(name: "email", databaseType: .string, formFieldType: .text, isRequired: true, isSearchable: true, isOrderingAllowed: true),
                .init(name: "password", databaseType: .string, formFieldType: .text, isRequired: true, isSearchable: true, isOrderingAllowed: true),
            ])
        ])
        
        let result = ModuleGenerator(descriptor).generate()
        let expectation = """
            public extension HookName {

            }

            struct UserModule: FeatherModule {
                let router = UserRouter()

                func boot(_ app: Application) throws {
                    app.migrations.add(UserMigrations.v1())

                    app.hooks.register(.webRoutes, use: router.webRoutesHook)
                    app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
                    app.hooks.register(.apiRoutes, use: router.apiRoutesHook)
                    app.hooks.register(.publicApiRoutes, use: router.publicApiRoutesHook)
                    app.hooks.register(.installUserPermissions, use: installUserPermissionsHook)
                    
                    try router.boot(app)
                }
                
                // MARK: - install
                    
                func installUserPermissionsHook(args: HookArguments) -> [User.Permission.Create] {
                    var permissions = User.availablePermissions()
                    permissions += User.Account.availablePermissions()
                    return permissions.map { .init($0) }
                }
            }
            """

        XCTAssertEqual(expectation, result)
    }
}
