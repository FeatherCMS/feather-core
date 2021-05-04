//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 02..
//

public struct RequestValidator {

    public var validators: [AsyncValidator]
    
    public init(_ validators: [AsyncValidator] = []) {
        self.validators = validators
    }
    
    /// this is magic, don't touch it
    public func validate(_ req: Request, message: String? = nil) -> EventLoopFuture<Void> {
        let initial: EventLoopFuture<[ValidationErrorDetail]> = req.eventLoop.future([])
        return validators.reduce(initial) { res, next -> EventLoopFuture<[ValidationErrorDetail]> in
            return res.flatMap { arr -> EventLoopFuture<[ValidationErrorDetail]> in
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
        .throwingMap { details in
            guard details.isEmpty else {
                throw ValidationAbort(abort: Abort(.badRequest, reason: message), details: details)
            }
        }
    }

    public func isValid(_ req: Request) -> EventLoopFuture<Bool> {
        return validate(req).map { true }.recover { _ in false }
    }
}





