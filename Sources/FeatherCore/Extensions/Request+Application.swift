//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 15..
//


public extension Request {

    var app: Application { application }

    var feather: Feather { app.feather }
}
