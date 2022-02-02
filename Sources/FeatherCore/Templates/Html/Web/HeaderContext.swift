//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//

public struct HeaderContext {

    public let logoLink: String
    public let main: NavigationContext?
    public let account: NavigationContext?
    
    public init(logoLink: String = "/",
                main: NavigationContext? = nil,
                account: NavigationContext? = nil) {
        self.logoLink = logoLink
        self.main = main
        self.account = account
    }
}
