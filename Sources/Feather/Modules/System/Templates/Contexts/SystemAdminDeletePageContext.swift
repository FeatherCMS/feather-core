//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

public struct SystemAdminDeletePageContext {

    public let title: String
    public let name: String
    public let type: String
    public let form: FormContext
    public let breadcrumbs: [LinkContext]
    
    public init(title: String,
                name: String,
                type: String,
                form: FormContext,
                breadcrumbs: [LinkContext] = []) {
        self.title = title
        self.name = name
        self.type = type
        self.form = form
        self.breadcrumbs = breadcrumbs
    }

}

