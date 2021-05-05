//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 05..
//

import FeatherTest
@testable import FeatherCore

extension PermissionGetObject: UUIDContent {}

final class UserPermissionApiTests: FeatherApiTestCase {
    
    override func modelName() -> String {
        "Permission"
    }
    
    override func endpoint() -> String {
        "user/permissions"
    }
    
    func testListPermissions() throws {
        try list(PermissionListObject.self)
    }
    
    func testCreatePermission() throws {
        let uuid = UUID().uuidString
        let input = PermissionCreateObject(namespace: "test" + uuid, context: "test", action: "test", name: "test")
        try create(input, PermissionGetObject.self) { item in
            XCTAssertEqual(item.namespace, "test" + uuid)
            XCTAssertEqual(item.context, "test")
            XCTAssertEqual(item.action, "test")
            XCTAssertEqual(item.name, "test")
        }
    }
    
    func testCreateInvalidPermission() throws {
        let input = PermissionCreateObject(namespace: "", context: "", action: "", name: "")
        try createInvalid(input) { error in
            XCTAssertEqual(error.details.count, 4)
        }
    }
    
    func testUpdatePermission() throws {
        let uuid = UUID().uuidString
        let input = PermissionCreateObject(namespace: "test" + uuid, context: "test", action: "test", name: "test")
        
        let uuid2 = UUID().uuidString
        let up = PermissionUpdateObject(namespace: "testUpdate" + uuid2, context: "test", action: "test", name: "test")
        
        try update(input, up, PermissionGetObject.self) { item in
            XCTAssertEqual(item.namespace, "testUpdate" + uuid2)
            XCTAssertEqual(item.context, "test")
            XCTAssertEqual(item.action, "test")
            XCTAssertEqual(item.name, "test")
        }
    }
    
    func testPatchPermission() throws {
        let uuid = UUID().uuidString
        let input = PermissionCreateObject(namespace: "test" + uuid, context: "test", action: "test", name: "test")
        
        let uuid2 = UUID().uuidString
        let up = PermissionPatchObject(namespace: "testPatch" + uuid2)
        
        try patch(input, up, PermissionGetObject.self) { item in
            XCTAssertEqual(item.namespace, "testPatch" + uuid2)
            XCTAssertEqual(item.context, "test")
            XCTAssertEqual(item.action, "test")
            XCTAssertEqual(item.name, "test")
        }
    }
    
    func testUniqueKeyFailure() throws {
        
        let uuid = UUID().uuidString
        let input = PermissionCreateObject(namespace: "test" + uuid, context: "test", action: "test", name: "test")
        try create(input, PermissionGetObject.self) { item in
            /// ok
        }

        try createInvalid(input) { error in
            XCTAssertEqual(error.details.count, 1)
            XCTAssertEqual(error.details[0].key, "permission")
            XCTAssertEqual(error.details[0].message, "Permission must be unique")
        }
    }

    func testDeletePermission() throws {
        let uuid = UUID().uuidString
        let input = PermissionCreateObject(namespace: "test" + uuid, context: "test", action: "test", name: "test")
        try delete(input, PermissionGetObject.self)
    }
    
    func testMissingDeletePermission() throws {
        try deleteMissing()
    }
}

