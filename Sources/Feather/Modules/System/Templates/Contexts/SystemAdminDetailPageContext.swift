//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 28..
//

public struct SystemAdminDetailPageContext {
    
    public let title: String
    public let fields: [DetailContext]
    public let navigation: [LinkContext]
    public let breadcrumbs: [LinkContext]
    public let actions: [LinkContext]

    public init(title: String,
                fields: [DetailContext],
                navigation: [LinkContext] = [],
                breadcrumbs: [LinkContext] = [],
                actions: [LinkContext] = []) {
        self.title = title
        self.fields = fields
        self.navigation = navigation
        self.breadcrumbs = breadcrumbs
        self.actions = actions
    }
}

