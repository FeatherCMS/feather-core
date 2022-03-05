//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import SwiftHtml

public struct FormAction {
    public var method: Method
    public var url: String?
    public var enctype: Enctype?
    
    public init(method: Method = .post,
                url: String? = nil,
                enctype: Enctype? = nil) {
        self.method = method
        self.url = url
        self.enctype = enctype
    }
}
