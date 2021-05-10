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

        /// NOTE: Total hack... will fix later on... sorry. :)
        var shouldInstall = true
        try! app.describe("Install step start must succeed")
            .get("/install/?next=true")
            .expect { res in
                if res.status == .notFound {
                    shouldInstall = false
                    return
                }
                /// must be ok or already installed, so not found
                guard res.status == .seeOther else {
                    fatalError("Something went wrong, Feather must be installed at this point")
                }
            }
            .test(.inMemory)
        
        if shouldInstall {
            struct PostData: Content {
                let formId: String
                let formToken: String
                let email: String
                let password: String
            }
            
            var installCookies: HTTPCookies?
            var userData: PostData!
            try! app.describe("Install step user must succeed")
                .get("/install/user/")
                .expect { res in
                    installCookies = res.headers.setCookie
                    /// this is not elegant at all, but it'll work for now...
                    let res: [String: String] = res.body.string.components(separatedBy: "\n")
                        .filter { $0.contains("name=\"form") }
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .reduce(into: [:]) { res, next in
                            let items = next.components(separatedBy: "\"")
                            guard items.count == 7 else {
                                return
                            }
                            let key = items[3]
                            let value = items[5]
                            res[key] = value
                        }
                    userData = PostData(formId: res["formId"]!, formToken: res["formToken"]!, email: "root@feathercms.com", password: "FeatherCMS")
                }
                .test(.inMemory)
            
            try! app.describe("Install step user must succeed")
                .post("/install/user/?next=true")
                .header("content-type", "application/x-www-form-urlencoded")
    //            .header("content-type", "multipart/form-data;boundary=\"boundary\"")
                .cookie(installCookies)
                .body(userData)
                .expect { res in
                    /// must be ok or already installed, so not found
                    guard res.status == .seeOther else {
                        fatalError("Something went wrong, Feather must be installed at this point")
                    }
                }
                .test(.inMemory)
            
            try! app.describe("Install step finish must succeed")
                .get("/install/finish/?next=true")
                .expect { res in
                    /// must be ok or already installed, so not found
                    guard res.status == .seeOther else {
                        fatalError("Something went wrong, Feather must be installed at this point")
                    }
                }
                .test(.inMemory)
        }
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
