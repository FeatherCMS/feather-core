//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 03..
//

import Foundation

public struct MenuListObject: Codable {

    public let id: UUID
    public let key: String
    public let name: String
    public let notes: String?
    
    public init(id: UUID,
                key: String,
                name: String,
                notes: String? = nil)
    {
        self.id = id
        self.key = key
        self.name = name
        self.notes = notes
    }
}
