//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor

public protocol CreateApi: ModelApi {
    
    associatedtype CreateObject: Codable
    
    func createValidators() -> [AsyncValidator]
    func mapCreate(_ req: Request, model: Model, input: CreateObject) async
}

public extension CreateApi {

    func createValidators() -> [AsyncValidator] {
        []
    }
}
