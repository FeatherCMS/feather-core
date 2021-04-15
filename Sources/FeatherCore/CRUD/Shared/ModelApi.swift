//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

public protocol ModelApi {
    associatedtype Model: FeatherModel
    
    init()
}
