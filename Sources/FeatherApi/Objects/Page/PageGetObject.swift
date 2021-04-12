//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 03..
//

import Foundation

public struct PageGetObject: Codable {

    public let id: UUID
    public let title: String
    public let content: String
    
    public init(id: UUID, title: String, content: String) {
        self.id = id
        self.title = title
        self.content = content
    }
}
