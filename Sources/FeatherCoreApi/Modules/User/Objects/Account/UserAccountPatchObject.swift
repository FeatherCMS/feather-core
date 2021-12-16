//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Foundation

extension UserAccount {
    
    public struct Patch: Codable {
        public var email: String?
        public var password: String?
        public var isRoot: Bool?

        public init(email: String? = nil,
                    password: String? = nil,
                    isRoot: Bool? = nil)
        {
            self.email = email
            self.password = password
            self.isRoot = isRoot
        }
    }

}
