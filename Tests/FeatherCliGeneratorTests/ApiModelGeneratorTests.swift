//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import XCTest
@testable import FeatherCliGenerator

final class ApiModelGeneratorTests: XCTestCase {

    func testGenerator() async throws {
        let descriptor = ModelDescriptor(name: "Account", properties: [
            .init(name: "email", databaseType: .string, formFieldType: .text, isRequired: true, isSearchable: true, isOrderingAllowed: true),
            .init(name: "password", databaseType: .string, formFieldType: .text, isRequired: true, isSearchable: true, isOrderingAllowed: true),
        ])
        
        let result = ApiModelGenerator(descriptor, module: "User").generate()
        let expectation = """
            public extension User {
                
                struct Account: FeatherApiModel {
                    public typealias Module = User
                }
            }

            public extension User.Account {

                    // MARK: -

                    struct List: Codable {
                        public let id: UUID
                        public let email: String
                public let password: String

                        public init(id: UUID,
                     email: String,
                     password: String) {
                self.id = id
                    self.email = email
                    self.password = password
                }
                    }

                    // MARK: -

                    struct Detail: Codable {
                        public let id: UUID
                        public let email: String
                public let password: String

                        public init(id: UUID,
                     email: String,
                     password: String) {
                self.id = id
                    self.email = email
                    self.password = password
                }
                    }

                    // MARK: -

                    struct Create: Codable {
                        public let email: String
                public let password: String

                        public init(     email: String,
                     password: String) {
                    self.email = email
                    self.password = password
                }
                    }


                    // MARK: -

                    struct Update: Codable {
                        public let email: String
                public let password: String

                        public init(     email: String,
                     password: String) {
                    self.email = email
                    self.password = password
                }
                    }

                    // MARK: -

                    struct Patch: Codable {
                        public let email: String
                public let password: String

                        public init(     email: String,
                     password: String) {
                    self.email = email
                    self.password = password
                }
                    }

            }
            """

        XCTAssertEqual(expectation, result)
    }
}
