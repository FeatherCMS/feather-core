//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Foundation

public struct LinkContext {

    public let icon: String?
    public let label: String
    public let url: String
    public let absolute: Bool
    public let isBlank: Bool
    public let priority: Int
    public let permission: String?
    public let style: String?

    public init(icon: String? = nil,
                label: String,
                url: String,
                absolute: Bool = true,
                isBlank: Bool = false,
                priority: Int = 0,
                permission: String? = nil,
                style: String? = nil) {
        self.icon = icon
        self.label = label
        self.url = url
        self.absolute = absolute
        self.isBlank = isBlank
        self.priority = priority
        self.permission = permission
        self.style = style
    }
}
