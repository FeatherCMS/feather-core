//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

public protocol FeatherRouter {
    func boot(_ app: Application) throws
}

public extension FeatherRouter {
    func boot(_ app: Application) throws {}
}
