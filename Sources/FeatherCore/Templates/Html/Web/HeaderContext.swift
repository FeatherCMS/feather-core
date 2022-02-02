//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//

public struct HeaderContext {

    public let main: NavigationContext?
    public let account: NavigationContext?
    
    public init(main: NavigationContext? = nil, account: NavigationContext? = nil) {
        self.main = main
        self.account = account
    }
}
