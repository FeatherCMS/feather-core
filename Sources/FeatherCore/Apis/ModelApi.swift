//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Foundation

public protocol ModelApi: Api {
    associatedtype Model: FeatherModel
    
    init()
}
