//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 28..
//

import XCTTauKit
import FeatherCore

open class FeatherTestCase: TauKitTestCase {
    
    static var cookies: HTTPCookies?
    static var app: Application!

    public var app: Application { Self.app }
    
    public var cookies: HTTPCookies? {
        get {
            Self.cookies
        }
        set {
            Self.cookies = newValue
        }
    }
    
    // MARK: - XCT api

    open override func setUpWithError() throws {
        /// NOTE: do not call super, we don't want to reset the template engine per test case
    }

    open override class func setUp() {
        super.setUp()

        let app = Application(.testing)

        Feather.useSQLiteDatabase(app)
        Feather.useLocalFileStorage(app)

        app.feather.use(testModules())
        
        try! Feather.resetPublicFiles(app)
        try! Feather.copyTemplatesIfNeeded(app)
        try! Feather.boot(app)

        try! app.describe("System install must succeed")
            .get("/install/")
            .expect { res in
                /// must be ok or already installed, so not found
                guard res.status == .ok || res.status == .notFound else {
                    fatalError("Something went wrong, Feather must be installed at this point")
                }
            }
            .test(.inMemory)
        
        self.app = app
    }
    
    open override class func tearDown() {
        app?.shutdown()
        app = nil

        super.tearDown()
    }
    
    // MARK: - api
    open class func testModules() -> [FeatherModule] {
        []
    }

    public func authenticate(email: String = "root@feathercms.com", password: String = "FeatherCMS") throws {
        guard Self.cookies == nil else {
            return
        }

        struct PostData: Content {
            let formId: String
            let formToken: String
            let email: String
            let password: String
        }

        try app.describe("Login page should be available")
            .get("/login/")
            .expect(.ok)
            .expect(.html)
            .test(.inMemory)
        
        try app.describe("User should be able to log in")
            .post("/login/")
            .body(PostData(formId: "", formToken: "", email: email, password: password))
            .expect(.seeOther)
            .expect { value in
                XCTAssertNotNil(value.headers.setCookie)
                XCTAssertTrue(value.body.string.isEmpty)
                Self.cookies = value.headers.setCookie
            }
            .test(.inMemory)
    }
    
    
}
