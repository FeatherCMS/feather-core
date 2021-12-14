import Vapor
import Fluent
import FluentSQLiteDriver
import SwiftHtml
import SwiftCss
import FeatherCore


public func configure(_ app: Application) throws {

    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.databases.use(.sqlite(.file("Resources/db.sqlite")), as: .sqlite)

    try Feather().start(app)

//    app.routes.get("style.css") { req in
//        req.css.render(Style())
//    }
}


