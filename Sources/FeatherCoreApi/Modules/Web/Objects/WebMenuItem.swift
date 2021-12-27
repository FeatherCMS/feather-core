//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

public extension Web {
    
    enum MenuItem: FeatherApiModel {
        public typealias Module = Web
        
        public static var pathKey: String { "items" }
    }
}

public extension Web.MenuItem {
    
    // MARK: -
    
    struct List: Codable {
        public let id: UUID
        public let label: String
        public let url: String
        public let icon: String?
        public let isBlank: Bool
        public let priority: Int
        public let permission: String?
        public let menuId: UUID
        
        public init(id: UUID,
                    label: String,
                    url: String,
                    icon: String? = nil,
                    isBlank: Bool = false,
                    priority: Int = 0,
                    permission: String? = nil,
                    menuId: UUID) {
            self.id = id
            self.label = label
            self.url = url
            self.icon = icon
            self.isBlank = isBlank
            self.priority = priority
            self.permission = permission
            self.menuId = menuId
        }
    }
    
    // MARK: -
    
    struct Detail: Codable {
        public let id: UUID
        public let label: String
        public let url: String
        public let icon: String?
        public let isBlank: Bool
        public let priority: Int
        public let permission: String?
        public let menuId: UUID
        
        public init(id: UUID,
                    label: String,
                    url: String,
                    icon: String? = nil,
                    isBlank: Bool = false,
                    priority: Int = 0,
                    permission: String? = nil,
                    menuId: UUID) {
            self.id = id
            self.label = label
            self.url = url
            self.icon = icon
            self.isBlank = isBlank
            self.priority = priority
            self.permission = permission
            self.menuId = menuId
        }
    }
    
    // MARK: -
    
    struct Create: Codable {
        public let label: String
        public let url: String
        public let icon: String?
        public let isBlank: Bool
        public let priority: Int
        public let permission: String?
        public let menuId: UUID
        
        public init(label: String,
                    url: String,
                    icon: String? = nil,
                    isBlank: Bool = false,
                    priority: Int = 0,
                    permission: String? = nil,
                    menuId: UUID) {
            self.label = label
            self.url = url
            self.icon = icon
            self.isBlank = isBlank
            self.priority = priority
            self.permission = permission
            self.menuId = menuId
        }
    }
    
    // MARK: -
    
    struct Update: Codable {
        public let label: String
        public let url: String
        public let icon: String?
        public let isBlank: Bool
        public let priority: Int
        public let permission: String?
        public let menuId: UUID
        
        public init(label: String,
                    url: String,
                    icon: String? = nil,
                    isBlank: Bool = false,
                    priority: Int = 0,
                    permission: String? = nil,
                    menuId: UUID) {
            self.label = label
            self.url = url
            self.icon = icon
            self.isBlank = isBlank
            self.priority = priority
            self.permission = permission
            self.menuId = menuId
        }
    }
    
    // MARK: -
    
    struct Patch: Codable {
        public let label: String?
        public let url: String?
        public let icon: String?
        public let isBlank: Bool?
        public let priority: Int?
        public let permission: String?
        public let menuId: UUID?
        
        public init(label: String? = nil,
                    url: String? = nil,
                    icon: String? = nil,
                    isBlank: Bool? = nil,
                    priority: Int? = nil,
                    permission: String? = nil,
                    menuId: UUID? = nil) {
            self.label = label
            self.url = url
            self.icon = icon
            self.isBlank = isBlank
            self.priority = priority
            self.permission = permission
            self.menuId = menuId
        }
    }
}
