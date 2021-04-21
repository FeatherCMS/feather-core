//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 03..
//

import Foundation

public struct SystemMenu: Codable {

    public let key: String
    public let notes: String?

    public let link: SystemMenuItem?
    public let items: [SystemMenuItem]

    public init(key: String,
                notes: String? = nil,
                link: SystemMenuItem? = nil,
                items: [SystemMenuItem] = []) {
        self.key = key
        self.notes = notes
        self.link = link
        self.items = items
    }
   
    
}


