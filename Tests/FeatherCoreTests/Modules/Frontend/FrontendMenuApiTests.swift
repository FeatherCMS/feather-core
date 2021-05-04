//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 04..
//

import FeatherTest
@testable import FeatherCore

extension MenuGetObject: UUIDContent {}

final class FrontendMenuApiTests: FeatherApiTestCase {
    
    override func modelName() -> String {
        "Menu"
    }
    
    override func endpoint() -> String {
        "frontend/menus"
    }
    
    func testListMenus() throws {
        try list(MenuListObject.self)
    }
    
    func testCreateMenu() throws {
        let uuid = UUID().uuidString
        let input = MenuCreateObject(key: "testKey" + uuid, name: "testName", notes: "testNotes")
        try create(input, MenuGetObject.self) { item in
            XCTAssertEqual(item.key, "testKey" + uuid)
            XCTAssertEqual(item.name, "testName")
            XCTAssertEqual(item.notes, "testNotes")
        }
    }
    
    func testCreateInvalidMenu() throws {
        let input = MenuCreateObject(key: "", name: "")
        try createInvalid(input) { error in
            XCTAssertEqual(error.details.count, 2)
            for detail in error.details {
                XCTAssertTrue(["name", "key"].contains(detail.key))
                XCTAssertTrue(["Name is required", "Key is required"].contains(detail.message))
            }
        }
    }
    
    func testUpdateMenu() throws {
        let uuid = UUID().uuidString
        let input = MenuCreateObject(key: "testUpdateKey" + uuid, name: "testUpdateName", notes: "testUpdateNotes")
        
        let uuid2 = UUID().uuidString
        let up = MenuUpdateObject(key: "testUpdateKey" + uuid2, name: "testUpdateName2", notes: "testUpdateNotes2")
        
        try update(input, up, MenuGetObject.self) { item in
            XCTAssertEqual(item.key, "testUpdateKey" + uuid2)
            XCTAssertEqual(item.name, "testUpdateName2")
            XCTAssertEqual(item.notes, "testUpdateNotes2")
        }
    }
    
    func testPatchMenu() throws {
        let uuid = UUID().uuidString
        let input = MenuCreateObject(key: "testPatchKey" + uuid, name: "testPatchName", notes: "testPatchNotes")
        
        let uuid2 = UUID().uuidString
        let up = MenuPatchObject(name: "testPatchName2" + uuid2)
        
        try patch(input, up, MenuGetObject.self) { item in
            XCTAssertEqual(item.key, "testPatchKey" + uuid)
            XCTAssertEqual(item.name, "testPatchName2" + uuid2)
            XCTAssertEqual(item.notes, "testPatchNotes")
        }
    }
    
    func testUniqueKeyFailure() throws {
        
        let uuid = UUID().uuidString
        let input = MenuCreateObject(key: "testUpdateKey" + uuid, name: "testUpdateName", notes: "testUpdateNotes")
        try create(input, MenuGetObject.self) { item in
            /// ok
        }

        try createInvalid(input) { error in
            XCTAssertEqual(error.details.count, 1)
            XCTAssertEqual(error.details[0].key, "key")
            XCTAssertEqual(error.details[0].message, "Key must be unique")
        }
    }

    func testDeleteMenu() throws {
        let uuid = UUID().uuidString
        let input = MenuCreateObject(key: "testDeleteKey" + uuid, name: "testDeleteName", notes: "testDeleteNotes")
        try delete(input, MenuGetObject.self)
    }
    
    func testMissingDeleteMenu() throws {
        try deleteMissing()
    }
}

