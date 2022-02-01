//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//

import Foundation

enum Access: String {
    case `private`
    case `fileprivate`
    case `internal`
    case `public`
    case `open`
}

extension Access: CustomDebugStringConvertible {
    var debugDescription: String {
        if self == .internal {
            return ""
        }
        return rawValue + " "
    }
}
