//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import XCTest
@testable import FeatherCliGenerator

final class AdminControllerGeneratorTests: XCTestCase {

    func testGenerator() async throws {
        let descriptor = ModelDescriptor(name: "Account", properties: [
            .init(name: "email", databaseType: .string, formFieldType: .input, isRequired: true, isSearchable: true, isOrderingAllowed: true),
            .init(name: "password", databaseType: .string, formFieldType: .input, isRequired: true, isSearchable: true, isOrderingAllowed: true),
        ])
        
        let result = AdminControllerGenerator(descriptor, module: "User").generate()
        let expectation = """
            struct UserAccountAdminController: AdminController {
                typealias ApiModel = User.Account
                typealias DatabaseModel = UserAccountModel
                typealias CreateModelEditor = UserAccountEditor
                typealias UpdateModelEditor = UserAccountEditor

                var listConfig: ListConfiguration {
                    .init(allowedOrders: [
                        "email",
                        "password",
                    ])
                }

                func listSearch(_ term: String) -> [ModelValueFilter<DatabaseModel>] {
                    [
                        \\.$email ~~ term,
                        \\.$password ~~ term,
                    ]
                }

                func listColumns() -> [ColumnContext] {
                    [
                        .init("email"),
                        .init("password"),
                    ]
                }

                func listCells(for model: DatabaseModel) -> [CellContext] {
                    [
                        .init(model.email, link: LinkContext(label: model.email, permission: ApiModel.permission(for: .detail).key)),
                        .init(model.password, link: LinkContext(label: model.password, permission: ApiModel.permission(for: .detail).key)),
                    ]
                }

                func detailFields(for model: DatabaseModel) -> [DetailContext] {
                    [
                        .init("id", model.uuid.string),
                        .init("email", model.email),
                        .init("password", model.password),
                    ]
                }

                func deleteInfo(_ model: DatabaseModel) -> String {
                    model.uuid.string
                }
            }

            """

        XCTAssertEqual(expectation, result)
    }
}
