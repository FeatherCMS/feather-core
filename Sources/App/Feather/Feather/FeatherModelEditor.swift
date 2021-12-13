//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 29..
//

import Vapor
import Fluent
import SwiftHtml

public protocol FeatherModelEditor {
    associatedtype Model: FeatherModel
    
    var model: Model { get }
    
    init(model: Model)
        
    @FormComponentBuilder
    var formFields: [FormComponent] { get }
}
