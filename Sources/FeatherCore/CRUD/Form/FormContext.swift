//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

import Foundation

public struct FormContext: Codable {
    public let id: String
    public let token: String
    public let title: String
    public let key: String
    public let modelId: String
    public let list: Link
    public let nav: [Link]
    public let notification: String?
    public let fields: [Context]
}

