//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

struct UserLoginContext {
    var index: WebIndexContext
    
    var title: String
    var message: String
    
    init(_ title: String, message: String) {
        self.title = title
        self.message = message
        self.index = .init(title: title)
    }
}
