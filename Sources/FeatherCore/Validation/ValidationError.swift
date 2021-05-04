//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 04..
//

struct ValidationError: Codable {
    let message: String?
    let details: [ValidationErrorDetail]
}

extension ValidationError: Content {}
