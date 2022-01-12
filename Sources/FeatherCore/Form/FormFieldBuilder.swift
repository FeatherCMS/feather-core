//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 26..
//

@resultBuilder
public enum FormFieldBuilder {
    
    public static func buildBlock(_ components: FormField...) -> [FormField] {
        components
    }
}

