//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

import Vapor
import Fluent

public struct SystemApi {
    private var db: Database
    
    public var permission: SystemPermissionApi { .init(.init(db)) }
    public var variable: SystemVariableApi { .init(.init(db)) }
    public var metadata: SystemMetadataApi { .init(.init(db)) }

    init(_ db: Database) {
        self.db = db
    }
}


public extension Request {

    var system: SystemApi { .init(self.db) }
}

public extension TemplateEngine {

    var system: SystemModuleTemplate {
        self.get(SystemModuleTemplate.self)
    }
}

