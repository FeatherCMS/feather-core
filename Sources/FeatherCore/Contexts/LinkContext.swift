//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Foundation
import Vapor
import SwiftHtml

public struct LinkContext {

    public enum Style {
        case `default`
        case destructive
        case custom(String)

        var rawValue: String? {
            switch self {
            case .`default`:
                return nil
            case .destructive:
                return "destructive"
            case .custom(let value):
                return value
            }
        }
    }

    public let icon: String?
    public let label: String
    public let path: String
    public let absolute: Bool
    public let isBlank: Bool
    public let dropLast: Int
    public let priority: Int
    public let permission: String?
    public let style: Style

    public init(icon: String? = nil,
                label: String,
                path: String = "",
                absolute: Bool = false,
                isBlank: Bool = false,
                dropLast: Int = 0,
                priority: Int = 0,
                permission: String? = nil,
                style: Style = .`default`) {
        self.icon = icon
        self.label = label
        self.path = path
        self.absolute = absolute
        self.isBlank = isBlank
        self.dropLast = dropLast
        self.priority = priority
        self.permission = permission
        self.style = style
    }
}

public extension LinkContext {
    
    func url(_ req: Request, _ infix: [PathComponent] = []) -> String {
        var finalUrl = path
        if !absolute {
            finalUrl = (req.url.path.pathComponents.dropLast(dropLast) + (infix + path.pathComponents)).path
        }
        return finalUrl.safePath()
    }
    
    func render(_ req: Request) -> Tag? {
        guard req.checkPermission(permission) else {
            return nil
        }
        return A(label)
            .href(url(req))
            .target(.blank, isBlank)
            .class(style.rawValue)
    }
    
    func renderTableAction(_ req: Request, for rowId: String) -> Tag? {
        guard req.checkPermission(permission) else {
            return nil
        }
        return Td {
            A(label)
                .href(url(req, rowId.pathComponents))
                .target(.blank, isBlank)
                .class(style.rawValue)
        }
    }
}
