//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

struct SystemMenuItemApi: CreateApiRepresentable, GetApiRepresentable {
    typealias Model = SystemMenuItemModel
    typealias CreateObject = String
    typealias GetObject = String
}

