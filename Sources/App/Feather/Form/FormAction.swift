//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import SwiftHtml

public struct FormAction {
    public var method: SwiftHtml.Method
    public var url: String?
    public var enctype: SwiftHtml.Enctype?
    
    public init(method: SwiftHtml.Method = .post,
                url: String? = nil,
                enctype: SwiftHtml.Enctype? = nil) {
        self.method = method
        self.url = url
        self.enctype = enctype
    }
}
