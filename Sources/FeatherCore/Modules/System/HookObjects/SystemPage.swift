//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 03..
//

import Foundation

public struct SystemPage: Codable {

    public let title: String
    public let content: String

    public init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}
