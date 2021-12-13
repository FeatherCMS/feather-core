//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor

public protocol UpdateApi: ModelApi {
    associatedtype UpdateObject: Codable
    
    func updateValidators() -> [AsyncValidator]
    func mapUpdate(_ req: Request, model: Model, input: UpdateObject) async
}

public extension UpdateApi {

    func updateValidators() -> [AsyncValidator] {
        []
    }
}
