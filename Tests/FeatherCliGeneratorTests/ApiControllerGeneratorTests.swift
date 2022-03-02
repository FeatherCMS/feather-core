//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import XCTest
@testable import FeatherCliGenerator

final class ApiControllerGeneratorTests: XCTestCase {

    func testGenerator() async throws {
        let descriptor = ModelDescriptor(name: "Account", properties: [
            .init(name: "email", databaseType: .string, formFieldType: .input, isRequired: true, isSearchable: true, isOrderingAllowed: true),
            .init(name: "password", databaseType: .string, formFieldType: .input, isRequired: true, isSearchable: true, isOrderingAllowed: true),
        ])
        
        let result = ApiControllerGenerator(descriptor, module: "User").generate()
        let expectation = """
        extension User.Account.List: Content {}
        extension User.Account.Detail: Content {}

        struct UserAccountApiController: ApiController {
            typealias ApiModel = User.Account
            typealias DatabaseModel = UserAccountModel
        
            func listOutput(_ req: Request, _ models: [DatabaseModel]) async throws -> [User.Account.List] {
                models.map { model in
                    .init(
                        id: model.uuid,
                        email: model.email,
                        password: model.password
                    )
                }
            }
        
            func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> User.Account.Detail {
                .init(
                    id: model.uuid,
                    email: model.email,
                    password: model.password
                )
            }
        
            func createInput(_ req: Request, _ model: DatabaseModel, _ input: User.Account.Create) async throws {
                model.email = input.email
                model.password = input.password
            }
        
            func updateInput(_ req: Request, _ model: DatabaseModel, _ input: User.Account.Update) async throws {
                model.email = input.email
                model.password = input.password
            }
        
            func patchInput(_ req: Request, _ model: DatabaseModel, _ input: User.Account.Patch) async throws {
                model.email = input.email ?? model.email
                model.password = input.password ?? model.password
            }
        
            @AsyncValidatorBuilder
            func validators(optional: Bool) -> [AsyncValidator] {
                KeyedContentValidator<String>.required("email", optional: optional)
                KeyedContentValidator<String>.required("password", optional: optional)
            }
        }
        
        """

        XCTAssertEqual(expectation, result)
    }
}
