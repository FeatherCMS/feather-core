//
//  RequestHandler.swift
//  RequestProcessing
//
//  Created by Tibor Bodecs on 2021. 03. 22..
//

protocol RequestController {
    
    var priority: Int { get }
    
    func boot(_ req: Request)
    func boot(req: Request) -> EventLoopFuture<Void>
    func bootResponse(req: Request) -> EventLoopFuture<Response?>
    
    func access(_ req: Request) -> Bool
    func access(req: Request) -> EventLoopFuture<Bool>
    func accessResponse(req: Request) -> EventLoopFuture<Response?>
    
    func load(_ req: Request)
    func load(req: Request) -> EventLoopFuture<Void>
    func loadResponse(req: Request) -> EventLoopFuture<Response?>
    
    func validation(_ req: Request) -> Bool
    func validation(req: Request) -> EventLoopFuture<Bool>
    func validationResponse(req: Request) -> EventLoopFuture<Response?>
    
    func failure(_ req: Request)
    func failure(req: Request) -> EventLoopFuture<Void>
    func failureResponse(req: Request) -> EventLoopFuture<Response?>
    
    func success(_ req: Request)
    func success(req: Request) -> EventLoopFuture<Void>
    func successResponse(req: Request) -> EventLoopFuture<Response?>
    
    func response(req: Request) -> EventLoopFuture<Response?>
}

extension RequestController {
    
    var priority: Int { 0 }
    
    func boot(_ req: Request) {}
    func boot(req: Request) -> EventLoopFuture<Void> { boot(req); return req.eventLoop.future() }
    func bootResponse(req: Request) -> EventLoopFuture<Response?> { req.eventLoop.future(nil) }
    
    func access(_ req: Request) -> Bool { true }
    func access(req: Request) -> EventLoopFuture<Bool> { req.eventLoop.future(access(req)) }
    func accessResponse(req: Request) -> EventLoopFuture<Response?> { req.eventLoop.future(nil) }
    
    func load(_ req: Request) {}
    func load(req: Request) -> EventLoopFuture<Void> { load(req); return req.eventLoop.future() }
    func loadResponse(req: Request) -> EventLoopFuture<Response?> { req.eventLoop.future(nil) }
    
    func validation(_ req: Request) -> Bool { true }
    func validation(req: Request) -> EventLoopFuture<Bool> { req.eventLoop.future(validation(req)) }
    func validationResponse(req: Request) -> EventLoopFuture<Response?> { req.eventLoop.future(nil) }
    
    func failure(_ req: Request) {}
    func failure(req: Request) -> EventLoopFuture<Void> { failure(req); return req.eventLoop.future() }
    func failureResponse(req: Request) -> EventLoopFuture<Response?> { req.eventLoop.future(nil) }
    
    func success(_ req: Request) {}
    func success(req: Request) -> EventLoopFuture<Void> { success(req); return req.eventLoop.future() }
    func successResponse(req: Request) -> EventLoopFuture<Response?> { req.eventLoop.future(nil) }
    
    func response(req: Request) -> EventLoopFuture<Response?> { req.eventLoop.future(nil) }
}
