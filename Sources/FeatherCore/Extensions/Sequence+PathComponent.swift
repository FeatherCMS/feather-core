//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 16..
//

import Vapor

public extension Sequence where Element == PathComponent {
    
    var path: String {
        string.safePath()
    }
}
