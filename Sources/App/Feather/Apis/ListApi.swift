//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor

public protocol ListApi: ModelApi {
    associatedtype ListObject: Content
    
    func mapList(model: Model) -> ListObject
}

