//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Foundation

extension UserAccount {

    public struct Detail: Codable {
        public var id: UUID
        public var email: String
        public var isRoot: Bool

        public init(id: UUID,
                    email: String,
                    isRoot: Bool) {
            self.id = id
            self.email = email
            self.isRoot = isRoot
        }
    }
}
