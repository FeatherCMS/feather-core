//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 03..
//

import Foundation

public struct MenuItemListObject: Codable {
    
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
                menuId: UUID)
    {
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
