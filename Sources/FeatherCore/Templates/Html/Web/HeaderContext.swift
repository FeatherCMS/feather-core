//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//

public struct HeaderContext {

    public let main: MenuContext?
    public let account: MenuContext?
    
    public init(main: MenuContext? = nil, account: MenuContext? = nil) {
        self.main = main
        self.account = account
    }
}
