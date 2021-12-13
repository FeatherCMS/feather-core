//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 02..
//

import Vapor

public struct KeyedRequestValidator: AsyncValidator {

    public let key: String
    public let message: String
    public let validation: (Request) async -> Bool
    
    public init(key: String, message: String, validation: @escaping (Request) async -> Bool) {
        self.key = key
        self.message = message
        self.validation = validation
    }

    public func validate(_ req: Request) async -> ValidationErrorDetail? {
        await validation(req) ? nil : error
    }
}
