//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public protocol FormComponent: Encodable {

    func load(req: Request) -> EventLoopFuture<Void>
    func process(req: Request) -> EventLoopFuture<Void>
    func validate(req: Request) -> EventLoopFuture<Bool>
    func write(req: Request) -> EventLoopFuture<Void>
    func save(req: Request) -> EventLoopFuture<Void>
    func read(req: Request) -> EventLoopFuture<Void>
}
