//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 02..
//

public struct ValidationError: Codable {

    public var key: String
    public var message: String
    
    public init(key: String, message: String) {
        self.key = key
        self.message = message
    }
}

extension ValidationError: Content {}
