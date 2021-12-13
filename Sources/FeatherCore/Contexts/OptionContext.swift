//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Foundation

public struct OptionContext {

    public let key: String
    public let label: String

    public init(key: String, label: String) {
        self.key = key
        self.label = label
    }
}
