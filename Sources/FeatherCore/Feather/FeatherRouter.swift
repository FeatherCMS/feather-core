//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

protocol FeatherRouter {
    func boot(_ app: Application) throws
}

extension FeatherRouter {
    func boot(_ app: Application) throws {}
}
