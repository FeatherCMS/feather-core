//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 02..
//

public protocol AsyncValidator {
    
    var key: String { get }
    var message: String { get }

    func validate(_ req: Request) async throws -> FeatherErrorDetail?
}

public extension AsyncValidator {

    var error: FeatherErrorDetail {
        .init(key: key, message: message)
    }
}
