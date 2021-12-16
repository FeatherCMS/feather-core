//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import Foundation

public struct AdminEditorPageContext {

    public let title: String
    public let form: FormContext
    public let navigation: [LinkContext]
    public let breadcrumbs: [LinkContext]

    public init(title: String,
                form: FormContext,
                navigation: [LinkContext] = [],
                breadcrumbs: [LinkContext] = []) {
        self.title = title
        self.form = form
        self.navigation = navigation
        self.breadcrumbs = breadcrumbs
    }
    
}

