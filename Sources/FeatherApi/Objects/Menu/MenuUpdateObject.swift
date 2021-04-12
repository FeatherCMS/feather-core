//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 03..
//

import Foundation

public struct MenuUpdateObject: Codable {

    public let key: String
    public let name: String
    public let icon: String?
    public let notes: String?
    public let permission: String?
    
    public init(key: String,
                name: String,
                icon: String? = nil,
                notes: String? = nil,
                permission: String? = nil)
    {
        self.key = key
        self.name = name
        self.icon = icon
        self.notes = notes
        self.permission = permission
    }
}


