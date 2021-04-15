//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

struct SystemMenuApi: CreateApiRepresentable, GetApiRepresentable {
    typealias Model = SystemMenuModel
    typealias CreateObject = String
    typealias GetObject = String
}
