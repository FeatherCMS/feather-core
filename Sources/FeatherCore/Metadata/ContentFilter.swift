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
    
    var priority: Int { get }

    /// filter function that transforms the input
    func filter(_ input: String, _ req: Request) -> EventLoopFuture<String>
}

public extension ContentFilter {
    /// use key as default label
    var label: String { key }
    
    var priority: Int { 0 }

    /// a content filter can be used as a form field string option
    var formFieldOption: FormFieldOption {
        .init(key: key, label: label)
    }
}
