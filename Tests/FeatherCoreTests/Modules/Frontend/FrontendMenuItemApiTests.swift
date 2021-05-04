//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 04..
//
import FeatherTest
@testable import FeatherCore

extension MenuItemGetObject: UUIDContent {}

final class FrontendMenuItemApiTests: FeatherApiTestCase {
    
    override func modelName() -> String {
        "Menu item"
    }
    
    override func endpoint() -> String {
        "frontend/menus"
    }
    
    func testListMenus() throws {
        try list(MenuListObject.self)
    }
    
    func testCreateMenuItem() throws {
        let uuid = UUID().uuidString
        let input = MenuCreateObject(key: "testKey" + uuid, name: "testName", notes: "testNotes")
        try authenticate()

        var menu: MenuGetObject!
        try app.describe("Menu creation should succeed")
            .post("/api/admin/" + "frontend/menus" + "/")
            .body(input)
            .cookie(cookies)
            .expect(.created)
            .expect(.json)
            .expect(MenuGetObject.self) { item in
                XCTAssertEqual(item.key, "testKey" + uuid)
                XCTAssertEqual(item.name, "testName")
                XCTAssertEqual(item.notes, "testNotes")
                menu = item
            }
            .test(.inMemory)
        
        let menuItemInput = MenuItemCreateObject(label: "test label", url: "test url", menuId: menu.id)
        try app.describe(modelName() + " creation should succeed")
            .post("/api/admin/" + "frontend/menus" + "/" + menu.id.uuidString + "/items/")
            .body(menuItemInput)
            .cookie(cookies)
            .expect(.created)
            .expect(.json)
            .expect(MenuItemGetObject.self) { item in
                XCTAssertEqual(item.label, "test label")
                XCTAssertEqual(item.url, "test url")
                XCTAssertEqual(item.menuId, menu.id)
            }
            .test(.inMemory)
        
        try app.describe("Menu get should succeed")
            .get("/api/admin/" + "frontend/menus" + "/" + menu.id.uuidString + "/")
            .cookie(cookies)
            .expect(.ok)
            .expect(.json)
            .expect(MenuGetObject.self) { item in
                XCTAssertEqual(item.items.count, 1)
            }
            .test(.inMemory)
        
        try app.describe("Menu item list should succeed")
            .get("/api/admin/" + "frontend/menus" + "/" + menu.id.uuidString + "/items/")
            .cookie(cookies)
            .expect(.ok)
            .expect(.json)
            .expect(PaginationContainer<MenuItemListObject>.self) { items in
                XCTAssertEqual(items.info.total, 1)
            }
            .test(.inMemory)
    }
    
}

