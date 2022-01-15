//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 15..
//

import Foundation
import FeatherCore
import Spec

fileprivate extension String {
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}


open class FeatherTestApp {

    public private(set) var app: Application
    public var cookies: HTTPCookies?
    
    public init() {
        self.app = Application(.testing)
    }

    open func configure() throws {
        
    }

    open func customInstallSteps() throws {
        
    }
    
    open func testModules() -> [FeatherModule] {
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

    open func setUp() throws {
        app.feather.boot()
        try configure()

        print("Setup", self.app, "-------------", app.directory.workingDirectory)

        try app.feather.start(testModules())

        if try checkInstall() {
            try installRootUser(email: "root@feathercms.com", password: "FeatherCMS")
            try customInstallSteps()
            try finishInstall()
        }
    }

    open func tearDown() {
        let path = app.feather.paths.base
        app.shutdown()
        do {
            try FileManager.default.removeItem(at: path)
        }
        catch {
            // do nothing...
        }
    }
}

private extension FeatherTestApp {

    func checkInstall() throws -> Bool {
        var shouldInstall = false
        try app.describe("Install step start must succeed")
            .get("/install/start/?next=true")
            .expect { res in
                shouldInstall = res.status == .seeOther
            }
            .test()
        return shouldInstall
    }

    func installRootUser(email: String, password: String) throws -> Void {
        struct PostData: Content {
            let formId: String
            let formToken: String
            let email: String
            let password: String
        }

        var installCookies: HTTPCookies?
        var userData: PostData!

        try app.describe("Install step user must succeed")
            .get("/install/user/")
            .expect { res in
                installCookies = res.headers.setCookie
                let bodyString = res.body.string
                let formId = bodyString.slice(from: "name=\"formId\" value=\"" , to: "\">")!
                let formToken = bodyString.slice(from: "name=\"formToken\" value=\"" , to: "\">")!
                userData = PostData(formId: formId, formToken: formToken, email: email, password: password)
            }
            .test()

        try app.describe("Install step user must succeed")
            .post("/install/user/?next=true")
            .header("Content-Type", "application/x-www-form-urlencoded")
//            .header("Content-Type", "multipart/form-data;boundary=\"boundary\"")
            .cookie(installCookies)
            .body(userData)
            .expect { res in
//                let error = res.body.string.slice(from: "<p class=\"error\">", to: "</p>")
                guard res.status == .seeOther else {
                    XCTFail("Something went wrong, Feather must be installed at this point")
                    return
                }
            }
            .test()
    }
    
    func finishInstall() throws {
        try app.describe("Install step finish must succeed")
            .get("/install/finish/?next=true")
            .expect { res in
                guard res.status == .seeOther else {
                    fatalError("Something went wrong, Feather must be installed at this point")
                }
            }
            .test()
    }
}
