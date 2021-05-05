//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 05..
//

import FeatherTest
@testable import FeatherCore

extension RoleGetObject: UUIDContent {}

final class UserRoleApiTests: FeatherApiTestCase {
    
    override func modelName() -> String {
        "Role"
    }
    
    override func endpoint() -> String {
        "user/roles"
    }
    
    func testListRoles() throws {
        try list(RoleListObject.self)
    }
    
    func testCreateRole() throws {
        let uuid = UUID().uuidString
        let input = RoleCreateObject(key: "testKey" + uuid, name: "testName", notes: "testNotes")
        try create(input, RoleGetObject.self) { item in
            XCTAssertEqual(item.key, "testKey" + uuid)
            XCTAssertEqual(item.name, "testName")
            XCTAssertEqual(item.notes, "testNotes")
        }
    }
    
    func testCreateInvalidRole() throws {
        let input = RoleCreateObject(key: "", name: "")
        try createInvalid(input) { error in
            XCTAssertEqual(error.details.count, 2)
            for detail in error.details {
                XCTAssertTrue(["name", "key"].contains(detail.key))
                XCTAssertTrue(["Name is required", "Key is required"].contains(detail.message))
            }
        }
    }
    
    func testUpdateRole() throws {
        let uuid = UUID().uuidString
        let input = RoleCreateObject(key: "testUpdateKey" + uuid, name: "testUpdateName", notes: "testUpdateNotes")
        
        let uuid2 = UUID().uuidString
        let up = RoleUpdateObject(key: "testUpdateKey" + uuid2, name: "testUpdateName2", notes: "testUpdateNotes2")
        
        try update(input, up, RoleGetObject.self) { item in
            XCTAssertEqual(item.key, "testUpdateKey" + uuid2)
            XCTAssertEqual(item.name, "testUpdateName2")
            XCTAssertEqual(item.notes, "testUpdateNotes2")
        }
    }
    
    func testPatchRole() throws {
        let uuid = UUID().uuidString
        let input = RoleCreateObject(key: "testPatchKey" + uuid, name: "testPatchName", notes: "testPatchNotes")
        
        let uuid2 = UUID().uuidString
        let up = RolePatchObject(name: "testPatchName2" + uuid2)
        
        try patch(input, up, RoleGetObject.self) { item in
            XCTAssertEqual(item.key, "testPatchKey" + uuid)
            XCTAssertEqual(item.name, "testPatchName2" + uuid2)
            XCTAssertEqual(item.notes, "testPatchNotes")
        }
    }
    
    func testUniqueKeyFailure() throws {
        
        let uuid = UUID().uuidString
        let input = RoleCreateObject(key: "testUpdateKey" + uuid, name: "testUpdateName", notes: "testUpdateNotes")
        try create(input, RoleGetObject.self) { item in
            /// ok
        }

        try createInvalid(input) { error in
            XCTAssertEqual(error.details.count, 1)
            XCTAssertEqual(error.details[0].key, "key")
            XCTAssertEqual(error.details[0].message, "Key must be unique")
        }
    }

    func testDeleteRole() throws {
        let uuid = UUID().uuidString
        let input = RoleCreateObject(key: "testDeleteKey" + uuid, name: "testDeleteName", notes: "testDeleteNotes")
        try delete(input, RoleGetObject.self)
    }
    
    func testMissingDeleteRole() throws {
        try deleteMissing()
    }
}

