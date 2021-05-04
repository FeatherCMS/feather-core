//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 04..
//

import FeatherTest
@testable import FeatherCore

extension PageGetObject: UUIDContent {}

final class FrontendPagesApiTests: FeatherApiTestCase {
    
    override func modelName() -> String {
        "Page"
    }
    
    override func endpoint() -> String {
        "frontend/pages"
    }

    func testListPages() throws {
        try list(PageListObject.self)
    }
    
    func testCreatePage() throws {
        let uuid = UUID().uuidString
        let input = PageCreateObject(title: "testPage" + uuid, content: "testContent")
        try create(input, PageGetObject.self) { item in
            XCTAssertEqual(item.title, "testPage" + uuid)
            XCTAssertEqual(item.content, "testContent")
        }
    }
    
    func testCreateInvalidVariable() throws {
        let input = PageCreateObject(title: "", content: "")
        try createInvalid(input) { error in
            XCTAssertEqual(error.details.count, 2)
            for detail in error.details {
                XCTAssertTrue(["title", "content"].contains(detail.key))
                XCTAssertTrue(["Title is required", "Content is required"].contains(detail.message))
            }
        }
    }
    
    func testUpdateVariable() throws {
        let uuid = UUID().uuidString
        let input = PageCreateObject(title: "testPage" + uuid, content: "testContent")
        
        let uuid2 = UUID().uuidString
        let up = PageUpdateObject(title: "testPage" + uuid2, content: "testContent")

        try update(input, up, PageGetObject.self) { item in
            XCTAssertEqual(item.title, "testPage" + uuid2)
            XCTAssertEqual(item.content, "testContent")
        }
    }
    
    func testPatchVariable() throws {
        let uuid = UUID().uuidString
        let input = PageCreateObject(title: "testPage" + uuid, content: "testContent")
        
        let uuid2 = UUID().uuidString
        let up = PagePatchObject(title: "testPage" + uuid2)

        try patch(input, up, PageGetObject.self) { item in
            XCTAssertEqual(item.title, "testPage" + uuid2)
            XCTAssertEqual(item.content, "testContent")
        }
    }
    
    func testDeleteVariable() throws {
        let uuid = UUID().uuidString
        let input = PageCreateObject(title: "testPage" + uuid, content: "testContent")
        try delete(input, PageGetObject.self)
    }
    
    func testMissingDeleteVariable() throws {
        try deleteMissing()
    }
}

