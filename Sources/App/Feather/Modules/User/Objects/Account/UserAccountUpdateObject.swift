//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor

extension UserAccount {
    
    public struct Update: Codable {
        public var email: String
        public var password: String
        public var root: Bool

        public init(email: String,
                    password: String,
                    root: Bool = false)
        {
            self.email = email
            self.password = password
            self.root = root
        }
    }

}