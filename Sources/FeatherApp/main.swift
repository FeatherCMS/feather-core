//
//  main.swift
//  Feather
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import Feather

import FluentSQLiteDriver
import Liquid
import LiquidLocalDriver
import Mail
import MailAwsDriver

public func configure(_ app: Application) throws {
    app.feather.boot()

    app.databases.use(.sqlite(.file(app.feather.paths.resources.path + "/db.sqlite")), as: .sqlite)
    
    app.fileStorages.use(.local(publicUrl: app.feather.publicUrl,
                                publicPath: app.feather.paths.public.path,
                                workDirectory: Feather.Directories.assets), as: .local)

    app.mailProviders.use(.ses(credentialProvider: .default, region: .eucentral1), as: .ses)

    try app.feather.start() //template: CustomSystemModuleTemplate())
}

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
