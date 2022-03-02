//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import XCTest
@testable import FeatherCliGenerator

final class MigrationGeneratorTests: XCTestCase {

    func testGenerator() async throws {
        
        let descriptor = ModuleDescriptor(name: "User", models: [
            ModelDescriptor(name: "Account", properties: [
                .init(name: "email", databaseType: .string, formFieldType: .input, isRequired: true, isSearchable: true, isOrderingAllowed: true),
                .init(name: "password", databaseType: .string, formFieldType: .input, isRequired: true, isSearchable: true, isOrderingAllowed: true),
            ])
        ])
        
        let result = MigrationGenerator(descriptor).generate()
        let expectation = """
            struct UserMigrations {
                
                struct v1: AsyncMigration {

                    func prepare(on db: Database) async throws {
                       try await db.schema(UserAccountModel.schema)
                            .id()
                            .field(UserAccountModel.FieldKeys.v1.email, .string, .required)
                            .field(UserAccountModel.FieldKeys.v1.password, .string, .required)
                            .create()
                    }

                    func revert(on db: Database) async throws {
                        try await db.schema(UserAccountModel.schema).delete()
                    }
                }
            }
            """
        
        XCTAssertEqual(expectation, result)
    }
}
