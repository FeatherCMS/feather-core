//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 18..
//

public protocol FeatherForm: AnyObject, FormComponent {
    associatedtype Model: FeatherModel
    
    var model: Model? { get set }
    
    init()
}
