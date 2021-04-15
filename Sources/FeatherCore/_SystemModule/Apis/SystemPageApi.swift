//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

struct SystemPageApi: CreateApiRepresentable, GetApiRepresentable {
    typealias Model = SystemPageModel
    typealias CreateObject = String
    typealias GetObject = String
}

