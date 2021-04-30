//
//  File.swift
//
//
//  Created by Tibor Bodecs on 2021. 04. 28..
//

import FeatherTest
@testable import FeatherCore

final class FeatherAdminTests: FeatherTestCase {
    
    func testAdmin() throws {
        try app.describe("Admin page should not be available for visitors")
            .get("/admin/")
            .expect(.seeOther)
            .test(.inMemory)
        
        try authenticate()
        
        try app.describe("Admin page should be available for authenticated users")
            .get("/admin/")
            .cookie(cookies)
            .expect(.ok)
            .expect(.html)
            .expect { res in
                XCTAssertTrue(res.body.string.contains("Admin"))
            }
            .test(.inMemory)
    }
}
