//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//

import Foundation

extension String {
    
    func indentLines(_ level: Int = 1) -> String {
        components(separatedBy: "\n").mapJoinLines(indent: level)
    }
}
