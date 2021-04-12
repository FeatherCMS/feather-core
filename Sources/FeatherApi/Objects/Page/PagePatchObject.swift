//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 03..
//

import Foundation

public struct PagePatchObject: Codable {

    public let title: String?
    public let content: String?
    
    public init(title: String? = nil, content: String? = nil) {
        self.title = title
        self.content = content
    }
}
