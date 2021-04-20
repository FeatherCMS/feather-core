//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 01..
//

public struct Notification: Codable {

    public enum `Type`: String, Codable {
        case info
        case success
        case warning
        case error
    }

    public let type: Type
    public let icon: String?
    public let title: String
    public let message: String?
    
    public init(type: Type = .info,
                icon: String? = nil,
                title: String,
                message: String? = nil) {
        self.type = type
        self.icon = icon
        self.title = title
        self.message = message
    }
}
