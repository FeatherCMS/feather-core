//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 05..
//

import FeatherTest
@testable import FeatherCore

extension AccountGetObject: UUIDContent {}

final class UserAccountApiTests: FeatherApiTestCase {
    
    override func modelName() -> String {
        "Account"
    }
    
    override func endpoint() -> String {
        "user/accounts"
    }
    
    func testListAccounts() throws {
        try list(AccountListObject.self)
    }
    
    func testCreateAccount() throws {
        let uuid = UUID().uuidString.lowercased()
        let input = AccountCreateObject(email: uuid + "@email.com", password: "password")
        try create(input, AccountGetObject.self) { item in
            XCTAssertEqual(item.email, uuid + "@email.com")
            
        }
    }
    
    func testCreateInvalidAccount() throws {
        let input = AccountCreateObject(email: "", password: "")
        try createInvalid(input) { error in
            XCTAssertEqual(error.details.count, 2)
        }
    }
    
    func testUpdateAccount() throws {
        let uuid = UUID().uuidString.lowercased()
        let input = AccountCreateObject(email: uuid + "@email.com", password: "password")
        
        let uuid2 = UUID().uuidString.lowercased()
        let up = AccountUpdateObject(email: uuid2 + "@email.com", password: "password")
        
        try update(input, up, AccountGetObject.self) { item in
            XCTAssertEqual(item.email, uuid2 + "@email.com")
        }
    }
    
    func testPatchAccount() throws {
        let uuid = UUID().uuidString.lowercased()
        let input = AccountCreateObject(email: uuid + "@email.com", password: "password")
        
        let uuid2 = UUID().uuidString.lowercased()
        let up = AccountPatchObject(email: uuid2 + "@email.com")
        
        try patch(input, up, AccountGetObject.self) { item in
            XCTAssertEqual(item.email, uuid2 + "@email.com")
        }
    }
    
    func testUniqueKeyFailure() throws {
        
        let uuid = UUID().uuidString.lowercased()
        let input = AccountCreateObject(email: uuid + "@email.com", password: "password")
        try create(input, AccountGetObject.self) { item in
            /// ok
        }

        try createInvalid(input) { error in
            XCTAssertEqual(error.details.count, 1)
            XCTAssertEqual(error.details[0].key, "email")
            XCTAssertEqual(error.details[0].message, "Email must be unique")
        }
    }

    func testDeleteAccount() throws {
        let uuid = UUID().uuidString.lowercased()
        let input = AccountCreateObject(email: uuid + "@email.com", password: "password")
        try delete(input, AccountGetObject.self)
    }
    
    func testMissingDeleteAccount() throws {
        try deleteMissing()
    }
}

