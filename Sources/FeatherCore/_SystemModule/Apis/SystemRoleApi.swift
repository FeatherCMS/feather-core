//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

struct SystemRoleApi: CreateApiRepresentable, GetApiRepresentable {
    typealias Model = SystemRoleModel
    typealias CreateObject = String
    typealias GetObject = String
}

