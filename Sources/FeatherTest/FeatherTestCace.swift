//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 28..
//

import FeatherCore
import FluentSQLiteDriver
import LiquidLocalDriver

extension Feather {
    static func useSQLiteDatabase(_ app: Application) {
        app.databases.use(.sqlite(.file("Tests/Resources/db.sqlite")), as: .sqlite)
    }
}

extension Feather {
    static func useLocalFileStorage(_ app: Application) {
        app.fileStorages.use(.local(publicUrl: Application.baseUrl,
                                    publicPath: Application.Paths.public.path,
                                    workDirectory: Application.Directories.assets), as: .local)
    }
}

open class FeatherTestCase: XCTestCase {

    private static var cookies: HTTPCookies?
    private static var app: Application!
    
    public var app: Application { Self.app }
    
    public var cookies: HTTPCookies? {
        get {
            Self.cookies
        }
        set {
            Self.cookies = newValue
        }
    }
    
    open class func testModules() -> [FeatherModule] {
        []
    }

    public func authenticate(email: String = "root@feathercms.com", password: String = "FeatherCMS") throws {
        guard cookies == nil else {
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
            .expect { [unowned self] value in
                XCTAssertNotNil(value.headers.setCookie)
                XCTAssertTrue(value.body.string.isEmpty)
                cookies = value.headers.setCookie
            }
            .test(.inMemory)
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
            .expect(.ok)
            .expect(.html)
            .test(.inMemory)
        
        self.app = app
    }
    
    open override class func tearDown() {
        app.shutdown()
        super.tearDown()
    }
}
