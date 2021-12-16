//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

public protocol FeatherModule {

    /// a unique key to identify the module
    static var moduleKey: String { get }
    static var pathComponent: PathComponent { get }
        
    func boot(_ app: Application) throws
    func config(_ app: Application) throws
}

public extension FeatherModule {
    
    static var moduleKey: String {
        String(describing: self).dropLast(6).lowercased()
    }
    
    static var pathComponent: PathComponent {
        .init(stringLiteral: moduleKey)
    }

    func boot(_ app: Application) throws {}
    func config(_ app: Application) throws {}
}
