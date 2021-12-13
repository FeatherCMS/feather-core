import Vapor
import Fluent
import FluentSQLiteDriver
import SwiftHtml
import SwiftCss



public func configure(_ app: Application) throws {

    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.databases.use(.sqlite(.file("Resources/db.sqlite")), as: .sqlite)

    try Feather().start(app)

//    Task.detached {
//        try await UserAccountModel(email: "root@feathercms.com",password: try! Bcrypt.hash("FeatherCMS"), isRoot: true).create(on: app.db)
//    }


//    app.routes.get("test") { req async throws -> String in
//
//        let todo = Todo(title: "example")
//        try await todo.create(on: req.db)
//        let todos = try await Todo.query(on: req.db).all()
//        return todos.map(\.title).joined(separator: ",")
//
//        "hello world"
//    }

    app.routes.get("style.css") { req in
        req.css.render(Style())
    }
}


