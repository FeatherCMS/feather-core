//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 02..
//

import Vapor

public protocol AsyncValidator {
    
    var key: String { get }
    var message: String { get }

    func validate(_ req: Request) async -> ValidationErrorDetail?
}

public extension AsyncValidator {

    var error: ValidationErrorDetail {
        .init(key: key, message: message)
    }
}