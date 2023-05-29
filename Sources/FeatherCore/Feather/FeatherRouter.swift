//
//  FeatherRouter.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

/// abstract router insterface
public protocol FeatherRouter {
    
    /// boot the routes
    func boot(_ app: Application) throws
}


public extension FeatherRouter {
    
    func boot(_ app: Application) throws {
        // nothing to do here...
    }
}
