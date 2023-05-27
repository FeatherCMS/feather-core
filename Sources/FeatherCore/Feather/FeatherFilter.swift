//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor

public protocol FeatherFilter {
    
    /// unique identifier key
    var key: String { get }
    
    /// public label for the content filter
    var label: String { get }
    
    var priority: Int { get }

    /// filter function that transforms the input
    func filter(_ input: String, _ req: Request) async throws -> String
}

public extension FeatherFilter {
    /// use key as default label
    var label: String { key }
    
    var priority: Int { 0 }
}
