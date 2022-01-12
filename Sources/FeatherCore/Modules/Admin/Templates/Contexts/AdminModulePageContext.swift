//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

public struct AdminModulePageContext {

    public let title: String
    public let message: String
    public let navigation: [LinkContext]
    
    public init(title: String,
                message: String,
                navigation: [LinkContext] = []) {
        self.title = title
        self.message = message
        self.navigation = navigation
    }
}

