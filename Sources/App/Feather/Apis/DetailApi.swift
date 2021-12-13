//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor

public protocol DetailApi: ModelApi {
    associatedtype DetailObject: Content
    
    func mapDetail(model: Model) -> DetailObject
}
