//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//

// https://www.w3schools.com/tags/tag_meta.asp
public struct StandardMetaContext {

    public let charset: String
    public let viewport: String
    public let noindex: Bool
    
    public init(charset: String, viewport: String, noindex: Bool) {
        self.charset = charset
        self.viewport = viewport
        self.noindex = noindex
    }
}
