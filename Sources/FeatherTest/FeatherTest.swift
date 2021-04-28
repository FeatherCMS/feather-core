//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 28..
//

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

