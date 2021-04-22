//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 03..
//

public struct FrontendMenuItem: Codable {
    
    public let label: String
    public let url: String
    public let icon: String?
    public let isBlank: Bool
    public let priority: Int
    public let permission: String?
    
    
    public init(label: String,
                url: String,
                icon: String? = nil,
                isBlank: Bool = false,
                priority: Int = 0,
                permission: String? = nil)
    {
        self.label = label
        self.url = url
        self.icon = icon
        self.isBlank = isBlank
        self.priority = priority
        self.permission = permission
    }
}
