//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 11..
//

import FeatherCore
import FluentMongoDriver

extension Feather {

    /// use the mysql database driver based on the environment
    static func useMongoDatabase() throws {
        try app.databases.use(.mongo(connectionString: "mongodb://localhost:27017/mydb3"), as: .mongo)
    }
}
