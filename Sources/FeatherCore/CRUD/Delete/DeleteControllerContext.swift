//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

import Foundation

public struct DeleteControllerContext: Codable {
    public struct Link: Codable {
        let title: String
        let url: String
    }
    let id: String
    let token: String
    let context: String
    let type: String
    let list: Link
}
