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
            .init(name: "email", databaseType: .string, formFieldType: .input, isRequired: true, isSearchable: true, isOrderingAllowed: true),
            .init(name: "password", databaseType: .string, formFieldType: .input, isRequired: true, isSearchable: true, isOrderingAllowed: true),
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
                    var id: UUID
                    public var email: String
                    public var password: String
                
                    init(
                        id: UUID,
                        email: String,
                        password: String
                    ) {
                        self.id = id
                        self.email = email
                        self.password = password
                    }
                }
                
                // MARK: -

                struct Detail: Codable {
                    var id: UUID
                    public var email: String
                    public var password: String
                
                    init(
                        id: UUID,
                        email: String,
                        password: String
                    ) {
                        self.id = id
                        self.email = email
                        self.password = password
                    }
                }
                
                // MARK: -

                struct Create: Codable {
                    public var email: String
                    public var password: String
                
                    init(
                        email: String,
                        password: String
                    ) {
                        self.email = email
                        self.password = password
                    }
                }
                
                // MARK: -

                struct Update: Codable {
                    public var email: String
                    public var password: String
                
                    init(
                        email: String,
                        password: String
                    ) {
                        self.email = email
                        self.password = password
                    }
                }
                
                // MARK: -

                struct Patch: Codable {
                    public var email: String?
                    public var password: String?
                
                    init(
                        email: String? = nil,
                        password: String? = nil
                    ) {
                        self.email = email
                        self.password = password
                    }
                }
                

            }
            """

        XCTAssertEqual(expectation, result)
    }
}
