//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 18..
//

public struct WebPageContext {
    public var index: WebIndexContext
    public var page: Web.Page.Detail
    
    public init(index: WebIndexContext, page: Web.Page.Detail) {
        self.index = index
        self.page = page
    }
}
