//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

import Vapor

public struct Feather {
    
    /*
     # .env example
     FEATHER_WORK_DIR=/Users/me/feather
     FEATHER_HTTPS=false
     FEATHER_DOMAIN=localhost
     FEATHER_PORT=8080
     FEATHER_MAX_BODY_SIZE=10mb
     */
    public static let workDir: String = Environment.fetch("FEATHER_WORK_DIR")
    public static let https: Bool = Bool(Environment.get("FEATHER_HTTPS") ?? "true") ?? true
    public static let hostname: String = Environment.get("FEATHER_HOSTNAME") ?? "127.0.0.1"
    public static let port: Int = Int(Environment.get("FEATHER_PORT") ?? "8080") ?? 8080
    public static let maxBodySize: ByteCount = ByteCount(stringLiteral: Environment.get("FEATHER_MAX_BODY_SIZE") ?? "10mb")
    public static let disableFileMiddleware: Bool = Bool(Environment.get("FEATHER_DISABLE_FILE_MIDDLEWARE") ?? "false") ?? false
    public static let disableApiSessionAuthMiddleware: Bool = Bool(Environment.get("FEATHER_DISABLE_API_SESSION_AUTH_MIDDLEWARE") ?? "false") ?? false

    public init() {
        
    }

    public func start(_ app: Application, _ modules: [FeatherModule] = []) throws {
        
        // NOTE: set proper max body size...
        app.routes.defaultMaxBodySize = "10mb"
        
        let modules: [FeatherModule] = [
            SystemModule(),
            UserModule(),
            CommonModule(),
            ApiModule(),
            AdminModule(),
            WebModule(),
        ] + modules

        for module in modules {
            try module.boot(app)
        }
        for module in modules {
            try module.config(app)
        }
        try app.autoMigrate().wait()
    }

}
