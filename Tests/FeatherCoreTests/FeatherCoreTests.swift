import FeatherTest
@testable import FeatherCore

final class FeatherCoreTests: FeatherTestCase {

    override class func testModules() -> [FeatherModule] {
        return []
    }

    func testWelcomePage() throws {
        try app.describe("Welcome page should be available")
            .get("/")
            .expect(.ok)
            .expect(.html)
            .expect { value in
                XCTAssertTrue(value.body.string.contains("Welcome"))
            }
            .test(.inMemory)
    }

    func testAboutPage() throws {
        try app.describe("About page should be available")
            .get("/about/")
            .expect(.ok)
            .expect(.html)
            .expect { value in
                XCTAssertTrue(value.body.string.contains("About"))
            }
            .test(.inMemory)
    }
    
    func testLogin() throws {
        /// NOTE: form id & token should be validated for login calls as well.
        struct PostData: Content {
            let formId: String
            let formToken: String
            let email: String
            let password: String
        }
        /*
         <input type="hidden" name="formId" value="7772E121-6FB9-4AE8-8E7E-8F2FCACDF22E">
         <input type="hidden" name="formToken" value="ierbRg7ahXlii+Q0ztDg7itJLjiMqpBrd0iQOuwqb9U=">
         */
        var sessionCookie: HTTPCookies?

        try app.describe("Welcome page should be available")
            .post("/login/")
            .body(PostData(formId: "", formToken: "", email: "root@feathercms.com", password: "FeatherCMS"))
            .expect(.seeOther)
            .expect { value in
                XCTAssertNotNil(value.headers.setCookie)
                XCTAssertTrue(value.body.string.isEmpty)
                sessionCookie = value.headers.setCookie
            }
            .test(.inMemory)
        
        try app.describe("Welcome page should be available")
            .get("/login/")
            .cookie(sessionCookie)
            .expect(.seeOther)
            .expect { value in
                XCTAssertTrue(value.body.string.isEmpty)
            }
            .test(.inMemory)
    }
    
    func testAdmin() throws {
        try app.describe("Admin page should not be available for visitors")
            .get("/admin/")
            .cookie(cookies)
            .expect(.seeOther)
            .test(.inMemory)
        
        try authenticate()
        
        try app.describe("Admin page should be available for authenticated users")
            .get("/admin/")
            .cookie(cookies)
            .expect(.ok)
            .expect(.html)
            .expect { value in
                XCTAssertTrue(value.body.string.contains("Admin"))
            }
            .test(.inMemory)
    }
}
