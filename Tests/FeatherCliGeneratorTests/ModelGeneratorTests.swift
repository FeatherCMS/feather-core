//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import XCTest
@testable import FeatherCliGenerator

final class ModelGeneratorTests: XCTestCase {

    func testGenerator() async throws {
        let descriptor = ModelDescriptor(name: "Account", properties: [
            .init(name: "email", databaseType: .string, formFieldType: .input, isRequired: true, isSearchable: true, isOrderingAllowed: true),
            .init(name: "password", databaseType: .string, formFieldType: .input, isRequired: true, isSearchable: true, isOrderingAllowed: true),
        ])
        
        let result = ModelGenerator(descriptor, module: "User").generate()
        let expectation = """
            final class UserAccountModel: FeatherDatabaseModel {
                typealias Module = UserModule

                struct FieldKeys {
                    struct v1 {
                        static var email: FieldKey { "email" }
                        static var password: FieldKey { "password" }
                    }
                }

                @ID() var id: UUID?
                @Field(key: FieldKeys.v1.email) var email: String
                @Field(key: FieldKeys.v1.password) var password: String

                init() {}

                init(id: UUID,
                     email: String,
                     password: String) {
                    self.id = id
                    self.email = email
                    self.password = password
                }
            }
            """

        XCTAssertEqual(expectation, result)
    }
}
