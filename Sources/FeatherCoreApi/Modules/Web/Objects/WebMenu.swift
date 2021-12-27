//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

public extension Web {
    enum Menu: FeatherApiModel {
        public typealias Module = Web
    }
}

public extension Web.Menu {
    
    // MARK: -
    
    struct List: Codable {
        public let id: UUID
        public let key: String
        public let name: String
        public let notes: String?
        
        public init(id: UUID,
                    key: String,
                    name: String,
                    notes: String? = nil) {
            self.id = id
            self.key = key
            self.name = name
            self.notes = notes
        }
    }
    
    // MARK: -
    
    struct Detail: Codable {
        public let id: UUID
        public let key: String
        public let name: String
        public let notes: String?
        public let items: [Web.MenuItem.List]
        
        public init(id: UUID,
                    key: String,
                    name: String,
                    notes: String? = nil,
                    items: [Web.MenuItem.List] = []) {
            self.id = id
            self.key = key
            self.name = name
            self.notes = notes
            self.items = items
        }
    }
    
    // MARK: -
    
    struct Create: Codable {
        public let key: String
        public let name: String
        public let icon: String?
        public let notes: String?
        public let permission: String?
        
        public init(key: String,
                    name: String,
                    icon: String? = nil,
                    notes: String? = nil,
                    permission: String? = nil) {
            self.key = key
            self.name = name
            self.icon = icon
            self.notes = notes
            self.permission = permission
        }
    }
    
    // MARK: -
    
    struct Update: Codable {
        public let key: String
        public let name: String
        public let icon: String?
        public let notes: String?
        public let permission: String?
        
        public init(key: String,
                    name: String,
                    icon: String? = nil,
                    notes: String? = nil,
                    permission: String? = nil) {
            self.key = key
            self.name = name
            self.icon = icon
            self.notes = notes
            self.permission = permission
        }
    }
    
    // MARK: -
    
    struct Patch: Codable {
        public let key: String?
        public let name: String?
        public let icon: String?
        public let notes: String?
        public let permission: String?
        
        public init(key: String? = nil,
                    name: String? = nil,
                    icon: String? = nil,
                    notes: String? = nil,
                    permission: String? = nil) {
            self.key = key
            self.name = name
            self.icon = icon
            self.notes = notes
            self.permission = permission
        }
    }
    
}
