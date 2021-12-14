import Vapor
import Fluent
import FluentSQLiteDriver
import SwiftHtml
import SwiftCss
import FeatherCore
import Liquid
import LiquidLocalDriver

public func configure(_ app: Application) throws {

    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.databases.use(.sqlite(.file("Resources/db.sqlite")), as: .sqlite)

    app.fileStorages.use(.local(publicUrl: Application.baseUrl,
                                publicPath: Application.Paths.public.path,
                                workDirectory: Application.Directories.assets), as: .local)
    
    try Feather().start(app)

//    app.routes.get("style.css") { req in
//        req.css.render(Style())
//    }
}


