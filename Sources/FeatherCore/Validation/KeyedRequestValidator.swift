//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 02..
//

public struct KeyedRequestValidator: AsyncValidator {

    public let key: String
    public let message: String

    public let asyncValidation: (Request) -> EventLoopFuture<Bool>
    
    public init(key: String, message: String, asyncValidation: @escaping (Request) -> EventLoopFuture<Bool>) {
        self.key = key
        self.message = message
        self.asyncValidation = asyncValidation
    }

    public func validate(_ req: Request) -> EventLoopFuture<ValidationError?> {
        asyncValidation(req).map { $0 ? nil : error }
    }
}
