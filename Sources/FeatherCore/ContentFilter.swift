//
//  ContentFilter.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 23..
//

/// a content filter can  synchronously transform an input string
public protocol ContentFilter: FormFieldOptionRepresentable {
    
    /// unique identifier key
    var key: String { get }
    
    /// public label for the content filter
    var label: String { get }

    /// filter function that transforms the input
    func filter(_ input: String) -> String
}

public extension ContentFilter {
    /// use key as default label
    var label: String { key }
    
    /// use input as default filter
    func filter(_ input: String) -> String { input }
    
    /// a content filter can be used as a form field option
    var formFieldOption: FormFieldOption {
        .init(key: self.key, label: self.label)
    }
}
