//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 13..
//

import Foundation

public struct WebInstallStepContext {

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
