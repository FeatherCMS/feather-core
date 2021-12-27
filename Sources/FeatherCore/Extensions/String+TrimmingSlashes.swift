//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

public extension String {
    
    func trimmingSlashes() -> String {
        split(separator: "/").joined(separator: "/")
    }
}
