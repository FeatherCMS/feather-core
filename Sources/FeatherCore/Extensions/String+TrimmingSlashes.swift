//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Foundation

public extension String {
    
    func trimmingSlashes() -> String {
        split(separator: "/").joined(separator: "/")
    }
}
