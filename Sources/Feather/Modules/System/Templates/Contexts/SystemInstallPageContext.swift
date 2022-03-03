//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

public struct SystemInstallPageContext {

    public let icon: String
    public let title: String
    public let message: String
    public let link: LinkContext
    
    public init(icon: String, title: String, message: String, link: LinkContext) {
        self.icon = icon
        self.title = title
        self.message = message
        self.link = link
    }
}
