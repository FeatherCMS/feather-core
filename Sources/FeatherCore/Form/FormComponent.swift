//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public protocol FormComponent: Encodable {
    
    //var key: String { get }

    func initialize(req: Request) -> EventLoopFuture<Void>
    func process(req: Request) throws // async?
    func validate(req: Request) -> EventLoopFuture<Bool>

    func load(req: Request) -> EventLoopFuture<Void>
    func save(req: Request) -> EventLoopFuture<Void>
    
    func render(req: Request) throws // async?
}
