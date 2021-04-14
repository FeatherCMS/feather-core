//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

import Foundation

public struct DeleteControllerContext: Codable {
    
    let id: String
    let token: String
    let context: String
    let type: String
    let list: Link
}
