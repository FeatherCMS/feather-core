//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 28..
//

import FeatherTest
@testable import FeatherCore

final class CommonVariablesApiTests: FeatherTestCase {
    
    func testListVariables() throws {
        try authenticate()

        try app.describe("Variables list should be available")
            .get("/api/admin/common/variables/")
            .cookie(cookies)
            .expect(.ok)
            .expect(.json)
            .expect(PaginationContainer<VariableListObject>.self)
            .test(.inMemory)
    }
    
    func testCreateVariable() throws {
        try authenticate()

        let uuid = UUID().uuidString
        
        try app.describe("Variables list")
            .post("/api/admin/common/variables/")
            .body(VariableCreateObject(key: "testKey" + uuid, name: "testName", value: "testValue", notes: "testNotes"))
            .cookie(cookies)
            .expect(.created)
            .expect(.json)
            .expect(VariableGetObject.self) { item in
                XCTAssertEqual(item.key, "testKey" + uuid)
                XCTAssertEqual(item.name, "testName")
                XCTAssertEqual(item.value, "testValue")
                XCTAssertEqual(item.notes, "testNotes")
            }
            .test(.inMemory)
    }
    
    func testCreateInvalidVariable() throws {
        try authenticate()
        
        try app.describe("Variable with missing key or name shouldn't be created")
            .post("/api/admin/common/variables/")
            .body(VariableCreateObject(key: "", name: ""))
            .cookie(cookies)
            .expect(.badRequest)
            .expect(.json)
            .expect(ApiError.self) { error in
                XCTAssertEqual(error.details.count, 2)
                for detail in error.details {
                    XCTAssertTrue(["name", "key"].contains(detail.key))
                    XCTAssertTrue(["Name is required", "Key is required"].contains(detail.message))
                }
            }
            .test(.inMemory)
    }
    
    func testUpdateVariable() throws {
        try authenticate()

        var variable: VariableGetObject!
        
        let uuid = UUID().uuidString
        
        try app.describe("Variable create")
            .post("/api/admin/common/variables/")
            .body(VariableCreateObject(key: "testUpdateKey" + uuid, name: "testUpdateName", value: "testUpdateValue", notes: "testUpdateNotes"))
            .cookie(cookies)
            .expect(.created)
            .expect(.json)
            .expect(VariableGetObject.self) { item in
                variable = item
                XCTAssertNotNil(variable)
            }
            .test(.inMemory)
        
        let uuid2 = UUID().uuidString
        
        try app.describe("Variable update")
            .put("/api/admin/common/variables/\(variable.id.uuidString)/")
            .body(VariableUpdateObject(key: "testUpdateKey" + uuid2, name: "testUpdateName2", value: "testUpdateValue2", notes: "testUpdateNotes2"))
            .cookie(cookies)
            .expect(.ok)
            .expect(.json)
            .expect(VariableGetObject.self) { item in
                XCTAssertEqual(item.key, "testUpdateKey" + uuid2)
                XCTAssertEqual(item.name, "testUpdateName2")
                XCTAssertEqual(item.value, "testUpdateValue2")
                XCTAssertEqual(item.notes, "testUpdateNotes2")
            }
            .test(.inMemory)
    }
    
    func testPatchVariable() throws {
        try authenticate()

        var variable: VariableGetObject!
        
        let uuid = UUID().uuidString
        
        try app.describe("Variable create")
            .post("/api/admin/common/variables/")
            .body(VariableCreateObject(key: "testPatchKey" + uuid, name: "testPatchName", value: "testPatchValue", notes: "testPatchNotes"))
            .cookie(cookies)
            .expect(.created)
            .expect(.json)
            .expect(VariableGetObject.self) { item in
                variable = item
                XCTAssertNotNil(variable)
            }
            .test(.inMemory)
        
        try app.describe("Variable patch")
            .patch("/api/admin/common/variables/\(variable.id.uuidString)/")
            .body(VariablePatchObject(name: "testPatchName2"))
            .cookie(cookies)
            .expect(.ok)
            .expect(.json)
            .expect(VariableGetObject.self) { item in
                XCTAssertEqual(item.key, "testPatchKey" + uuid)
                XCTAssertEqual(item.name, "testPatchName2")
                XCTAssertEqual(item.value, "testPatchValue")
                XCTAssertEqual(item.notes, "testPatchNotes")
            }
            .test(.inMemory)
    }
    
    func testUniqueKeyFailure() throws {
        try authenticate()

        let uuid = UUID().uuidString
        
        try app.describe("Variable create")
            .post("/api/admin/common/variables/")
            .body(VariableCreateObject(key: "testUpdateKey" + uuid, name: "testUpdateName", value: "testUpdateValue", notes: "testUpdateNotes"))
            .cookie(cookies)
            .expect(.created)
            .expect(.json)
            .expect(VariableGetObject.self)
            .test(.inMemory)
        
        try app.describe("Variable create")
            .post("/api/admin/common/variables/")
            .body(VariableCreateObject(key: "testUpdateKey" + uuid, name: "testUpdateName", value: "testUpdateValue", notes: "testUpdateNotes"))
            .cookie(cookies)
            .expect(.badRequest)
            .expect(.json)
            .expect(ApiError.self) { error in
                XCTAssertEqual(error.details.count, 1)
                XCTAssertEqual(error.details[0].key, "key")
                XCTAssertEqual(error.details[0].message, "Key must be unique")
            }
            .test(.inMemory)
    }
    
    func testDeleteVariable() throws {
        try authenticate()

        var variable: VariableGetObject!

        let uuid = UUID().uuidString

        try app.describe("Variable create")
            .post("/api/admin/common/variables/")
            .body(VariableCreateObject(key: "testDeleteKey" + uuid, name: "testDeleteName", value: "testDeleteValue", notes: "testDeleteNotes"))
            .cookie(cookies)
            .expect(.created)
            .expect(.json)
            .expect(VariableGetObject.self) { item in
                variable = item
                XCTAssertNotNil(variable)
            }
            .test(.inMemory)

        try app.describe("Variable delete should return with no content response")
            .delete("/api/admin/common/variables/\(variable.id.uuidString)/")
            .cookie(cookies)
            .expect(.noContent)
            .test(.inMemory)
    }
    
    func testMissingDeleteVariable() throws {
        try authenticate()
        
        let uuid = UUID().uuidString

        try app.describe("Missing variable delete should return not found error")
            .delete("/api/admin/common/variables/\(uuid)/")
            .cookie(cookies)
            .expect(.notFound)
            .test(.inMemory)
    }
}

