//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

struct SystemUserApi: CreateApiRepresentable, GetApiRepresentable {
    typealias Model = SystemUserModel
    typealias CreateObject = String
    typealias GetObject = String
    
    
}

