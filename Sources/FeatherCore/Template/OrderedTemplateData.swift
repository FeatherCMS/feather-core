//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 07..
//

import Foundation

public struct OrderedTemplateData {

    public let object: TemplateDataRepresentable
    public let order: Int
    
    public init(_ object: TemplateDataRepresentable, order: Int = 0) {
        self.object = object
        self.order = order
    }
}
