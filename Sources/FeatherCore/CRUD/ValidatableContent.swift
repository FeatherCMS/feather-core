//
//  ValidatableContent.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 25..
//

public protocol ValidatableContent: Content, Validatable {
    
}

public extension ValidatableContent {
    static func validations(_ validations: inout Validations) {}
}
