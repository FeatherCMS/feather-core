//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 26..
//

import Foundation

@resultBuilder
public enum FormComponentBuilder {
    
    public static func buildBlock(_ components: FormComponent...) -> [FormComponent] {
        components
    }
}

