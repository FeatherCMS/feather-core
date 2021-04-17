//
//  ViewController.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//


public protocol ModelApi {
    associatedtype Model: FeatherModel
    
    init()
}


public protocol ModelController {
    
    associatedtype Model: FeatherModel
}
