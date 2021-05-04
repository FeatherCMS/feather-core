//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 28..
//

import FeatherTest
@testable import FeatherCore

extension VariableGetObject: UUIDContent {}

final class CommonVariablesApiTests: FeatherApiTestCase {
    
    override func modelName() -> String {
        "Variable"
    }
    
    override func endpoint() -> String {
        "common/variables"
    }
    
    func testListVariables() throws {
        try list(VariableListObject.self)
    }
    
    func testCreateVariable() throws {
        let uuid = UUID().uuidString
        let input = VariableCreateObject(key: "testKey" + uuid, name: "testName", value: "testValue", notes: "testNotes")
        try create(input, VariableGetObject.self) { item in
            XCTAssertEqual(item.key, "testKey" + uuid)
            XCTAssertEqual(item.name, "testName")
            XCTAssertEqual(item.value, "testValue")
            XCTAssertEqual(item.notes, "testNotes")
        }
    }
    
    func testCreateInvalidVariable() throws {
        let input = VariableCreateObject(key: "", name: "")
        try createInvalid(input) { error in
            XCTAssertEqual(error.details.count, 2)
            for detail in error.details {
                XCTAssertTrue(["name", "key"].contains(detail.key))
                XCTAssertTrue(["Name is required", "Key is required"].contains(detail.message))
            }
        }
    }
    
    func testUpdateVariable() throws {
        let uuid = UUID().uuidString
        let input = VariableCreateObject(key: "testUpdateKey" + uuid, name: "testUpdateName", value: "testUpdateValue", notes: "testUpdateNotes")
        
        let uuid2 = UUID().uuidString
        let up = VariableUpdateObject(key: "testUpdateKey" + uuid2, name: "testUpdateName2", value: "testUpdateValue2", notes: "testUpdateNotes2")
        
        try update(input, up, VariableGetObject.self) { item in
            XCTAssertEqual(item.key, "testUpdateKey" + uuid2)
            XCTAssertEqual(item.name, "testUpdateName2")
            XCTAssertEqual(item.value, "testUpdateValue2")
            XCTAssertEqual(item.notes, "testUpdateNotes2")
        }
    }
    
    func testPatchVariable() throws {
        let uuid = UUID().uuidString
        let input = VariableCreateObject(key: "testPatchKey" + uuid, name: "testPatchName", value: "testPatchValue", notes: "testPatchNotes")
        
        let uuid2 = UUID().uuidString
        let up = VariablePatchObject(name: "testPatchName2" + uuid2)
        
        try patch(input, up, VariableGetObject.self) { item in
            XCTAssertEqual(item.key, "testPatchKey" + uuid)
            XCTAssertEqual(item.name, "testPatchName2" + uuid2)
            XCTAssertEqual(item.value, "testPatchValue")
            XCTAssertEqual(item.notes, "testPatchNotes")
        }
    }
    
    func testUniqueKeyFailure() throws {
        
        let uuid = UUID().uuidString
        let input = VariableCreateObject(key: "testUpdateKey" + uuid, name: "testUpdateName", value: "testUpdateValue", notes: "testUpdateNotes")
        try create(input, VariableGetObject.self) { item in
            /// ok
        }

        try createInvalid(input) { error in
            XCTAssertEqual(error.details.count, 1)
            XCTAssertEqual(error.details[0].key, "key")
            XCTAssertEqual(error.details[0].message, "Key must be unique")
        }
    }
    
    func testDeleteVariable() throws {
        let uuid = UUID().uuidString
        let input = VariableCreateObject(key: "testDeleteKey" + uuid, name: "testDeleteName", value: "testDeleteValue", notes: "testDeleteNotes")
        try delete(input, VariableGetObject.self)
    }
    
    func testMissingDeleteVariable() throws {
        try deleteMissing()
    }
}

