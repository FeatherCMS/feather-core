//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 21..
//

import SwiftCss

public protocol CssRepresentable {
    
    @RuleBuilder
    func rules(_ req: Request) -> [Rule]
}
