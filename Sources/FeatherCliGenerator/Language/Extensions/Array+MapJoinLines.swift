//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//

import Foundation

extension Array where Element == String {
    
    func mapJoinLines(indent level: Int = 1) -> String {
        map { String(repeating: " ", count: level * 4) + $0 }.joined(separator: "\n")
    }
}
