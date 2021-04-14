//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

import Foundation

public struct GetViewContext: Codable {

    public struct Field: Codable {
        public let label: String
        public let value: String
    }

    public let title: String
    public let key: String
    public let list: Link
    public let nav: [Link]
    public let fields: [Field]
}


