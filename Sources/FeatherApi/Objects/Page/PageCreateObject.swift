//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 03. 28..
//

import Foundation

public struct PageCreateObject: Codable {

    public let title: String
    public let content: String

    public init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}
