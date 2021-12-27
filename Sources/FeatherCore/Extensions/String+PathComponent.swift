//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 13..
//

public extension String {
    
    /// Converts a string into `PathComponent`.
    var pathComponent: PathComponent {
        .init(stringLiteral: self)
    }
}
