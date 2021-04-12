//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 03..
//

import Foundation

public struct MenuItemPatchObject: Codable {
    
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
                menuId: UUID? = nil)
    {
        self.label = label
        self.url = url
        self.icon = icon
        self.isBlank = isBlank
        self.priority = priority
        self.permission = permission
        self.menuId = menuId
    }
}
