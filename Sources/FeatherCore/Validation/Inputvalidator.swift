//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 02..
//

public struct InputValidator {

    public var validators: [AsyncValidator]
    
    public init(_ validators: [AsyncValidator] = []) {
        self.validators = validators
    }
    
    /// this is magic, don't touch it
    public func validateResult(_ req: Request) -> EventLoopFuture<[ValidationError]> {
        let initial: EventLoopFuture<[ValidationError]> = req.eventLoop.future([])
        return validators.reduce(initial) { res, next -> EventLoopFuture<[ValidationError]> in
            return res.flatMap { arr -> EventLoopFuture<[ValidationError]> in
                if arr.contains(where: { $0.key == next.key }) {
                    return req.eventLoop.future(arr)
                }
                return next.validate(req).map { result in
                    if let result = result {
                        return arr + [result]
                    }
                    return arr
                }
            }
        }
    }
    
    public func validate(_ req: Request) -> EventLoopFuture<Bool> {
        validateResult(req).map { $0.isEmpty }
    }

}





