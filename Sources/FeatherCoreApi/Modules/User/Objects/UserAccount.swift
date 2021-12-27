//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

public extension User {
    
    struct Account: FeatherApiModel {
        public typealias Module = User
    }
}

public extension User.Account {
    
    // MARK: -
    
    struct List: Codable {
        public var id: UUID
        public var email: String
        
        public init(id: UUID,
                    email: String) {
            self.id = id
            self.email = email
        }
    }
    
    // MARK: -
    
    struct Detail: Codable {
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
    
    // MARK: -
    
    struct Create: Codable {
        public var email: String
        public var password: String
        public var isRoot: Bool
        
        public init(email: String,
                    password: String,
                    isRoot: Bool = false) {
            self.email = email
            self.password = password
            self.isRoot = isRoot
        }
    }
    
    // MARK: -
    
    struct Update: Codable {
        public var email: String
        public var password: String
        public var isRoot: Bool
        
        public init(email: String,
                    password: String,
                    isRoot: Bool = false) {
            self.email = email
            self.password = password
            self.isRoot = isRoot
        }
    }
    
    // MARK: -
    
    struct Patch: Codable {
        public var email: String?
        public var password: String?
        public var isRoot: Bool?
        
        public init(email: String? = nil,
                    password: String? = nil,
                    isRoot: Bool? = nil) {
            self.email = email
            self.password = password
            self.isRoot = isRoot
        }
    }
}
