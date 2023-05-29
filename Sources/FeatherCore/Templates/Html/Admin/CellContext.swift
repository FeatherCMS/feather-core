//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 28..
//

import FeatherObjects

public struct CellContext {

    public enum `Type`: String {
        case text
        case image
    }

    public let value: String?
    public let link: LinkContext?
    public let type: `Type`
    public let placeholder: String?

    public init(_ value: String?,
                link: LinkContext? = nil,
                type: `Type` = .text,
                placeholder: String? = nil) {
        self.type = type
        self.value = value
        self.link = link
        self.placeholder = placeholder
    }
    
    public static func link(_ name: String, _ permission: FeatherPermission? = nil) -> CellContext {
        .init(name, link: LinkContext(label: name, permission: permission?.key))
    }

    public static func image(_ value: String?, placeholder: String? = nil, link: LinkContext? = nil) -> CellContext {
        .init(value, link: link, type: .image, placeholder: placeholder)
    }
}
