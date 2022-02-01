//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//

public struct BreadcrumbContext {
    
    public let links: [LinkContext]
    
    public init(links: [LinkContext]) {
        self.links = links
    }
}
