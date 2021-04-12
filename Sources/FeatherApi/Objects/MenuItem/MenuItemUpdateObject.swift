//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 03..
//

import Foundation

public struct MenuItemUpdateObject: Codable {
    
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
                menuId: UUID)
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
