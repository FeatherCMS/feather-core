//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 02..
//

import Vapor
import Liquid

public extension String {
    
    /// Resolves a key using the file storage
    func resolve(_ req: Request) -> String {
        req.fs.resolve(key: self)
    }
}

