//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//

import SwiftSvg

public struct HeaderContext {

    public struct Action {

        public let icon: Svg
        public let title: String
        public let link: String
        
        public init(icon: Svg, title: String, link: String) {
            self.icon = icon
            self.title = title
            self.link = link
        }
    }
    
    public let title: String
    public let logoLink: String
    public let main: NavigationContext?
    public let action: Action?
    
    public init(title: String,
                logoLink: String = "/",
                main: NavigationContext? = nil,
                action: Action? = nil) {
        self.title = title
        self.logoLink = logoLink
        self.main = main
        self.action = action
    }
}
