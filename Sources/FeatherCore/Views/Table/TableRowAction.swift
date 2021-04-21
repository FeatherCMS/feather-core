//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//

public struct TableRowAction: Encodable {
    
    public let label: String
    public let icon: String
    public let url: String
    public let permission: String?
    

    public init(label: String, icon: String, url: String, permission: String? = nil) {
        self.label = label
        self.icon = icon
        self.permission = permission
        self.url = url
    }
}
