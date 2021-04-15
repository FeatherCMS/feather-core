//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

struct SystemPermissionApi: CreateApiRepresentable, GetApiRepresentable {
    typealias Model = SystemPermissionModel
    typealias CreateObject = String
    typealias GetObject = String
}

