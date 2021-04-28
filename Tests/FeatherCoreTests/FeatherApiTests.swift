//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 28..
//

import FeatherTest
@testable import FeatherCore

final class FeatherApiTests: FeatherTestCase {
    
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
            .expect(.ok)
            .expect(.json)
            .expect(VariableGetObject.self) { item in
                XCTAssertEqual(item.key, "testKey" + uuid)
                XCTAssertEqual(item.name, "testName")
                XCTAssertEqual(item.value, "testValue")
                XCTAssertEqual(item.notes, "testNotes")
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
            .expect(.ok)
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
    
    func testUniqueKeyFailure() throws {
        try authenticate()

        let uuid = UUID().uuidString
        
        try app.describe("Variable create")
            .post("/api/admin/common/variables/")
            .body(VariableCreateObject(key: "testUpdateKey" + uuid, name: "testUpdateName", value: "testUpdateValue", notes: "testUpdateNotes"))
            .cookie(cookies)
            .expect(.ok)
            .expect(.json)
            .expect(VariableGetObject.self)
            .test(.inMemory)
        
        try app.describe("Variable create")
            .post("/api/admin/common/variables/")
            .body(VariableCreateObject(key: "testUpdateKey" + uuid, name: "testUpdateName", value: "testUpdateValue", notes: "testUpdateNotes"))
            .cookie(cookies)
            .expect(.badRequest)
            .expect(.json)
            .expect([ValidationError].self) { content in
                XCTAssertEqual(content.count, 1)
                XCTAssertEqual(content[0].key, "key")
                XCTAssertEqual(content[0].message, "Key must be unique")
            }
            .test(.inMemory)
    }
}

