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

    func render(req: Request, template: String, context: Renderer.Context) -> EventLoopFuture<View>
}

public extension ModelController {

    func render(req: Request, template: String, context: Renderer.Context) -> EventLoopFuture<View> {
        req.tau.render(template: template, context: context)
    }
}
