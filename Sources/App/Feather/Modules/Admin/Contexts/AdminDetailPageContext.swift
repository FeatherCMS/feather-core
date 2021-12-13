//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 28..
//

import Foundation

public struct AdminDetailPageContext {
    
    public let title: String
    public let fields: [FieldContext]
    public let navigation: [LinkContext]
    public let breadcrumbs: [LinkContext]

    public init(title: String,
                fields: [FieldContext],
                navigation: [LinkContext] = [],
                breadcrumbs: [LinkContext] = []) {
        self.title = title
        self.fields = fields
        self.navigation = navigation
        self.breadcrumbs = breadcrumbs
    }
}

