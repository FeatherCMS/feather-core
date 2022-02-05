//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 05..
//

import SwiftHtml

public final class Container: Div {
    
    public override init(@TagBuilder _ builder: () -> [Tag]) {
        super.init(builder)
        
        _ = self.class("container")
    }
}
