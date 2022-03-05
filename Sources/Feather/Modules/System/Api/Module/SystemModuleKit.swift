//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

import Vapor

public struct SystemApi {
    private var req: Request
    
    public var permission: SystemPermissionApi { .init(.init(req)) }
    public var variable: SystemVariableApi { .init(.init(req)) }
    public var metadata: SystemMetadataApi { .init(.init(req)) }

    init(_ req: Request) {
        self.req = req
    }
}

public extension Request {

    var system: SystemApi { .init(self) }
}

public extension TemplateEngine {

    var system: SystemModuleTemplate {
        self.get(SystemModuleTemplate.self)
    }
}

