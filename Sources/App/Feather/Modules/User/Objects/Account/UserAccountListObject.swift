//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor

extension UserAccount {

    public struct List: Codable {
        public var id: UUID
        public var email: String

        public init(id: UUID,
                    email: String)
        {
            self.id = id
            self.email = email
        }
    }

}
