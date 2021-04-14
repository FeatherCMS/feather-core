//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

import Foundation

public struct Link: Codable {

    public let label: String
    public let url: String
    public let isBlank: Bool

    public init(label: String, url: String, isBlank: Bool = false) {
        self.label = label
        self.url = url
        self.isBlank = isBlank
    }
    
}
