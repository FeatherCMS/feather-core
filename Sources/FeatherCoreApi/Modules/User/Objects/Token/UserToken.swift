//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Foundation

public struct UserToken {

    public let id: UUID
    public let value: String
    public let user: UserAccount
    
    public init(id: UUID, value: String, user: UserAccount) {
        self.id = id
        self.value = value
        self.user = user
    }
}

