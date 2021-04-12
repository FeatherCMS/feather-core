//
//  CreateContentRepresentable.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 25..
//

public protocol CreateContentRepresentable: GetContentRepresentable {
    associatedtype CreateContent: ValidatableContent

    func create(_: CreateContent) throws
}

public extension CreateContentRepresentable {
    func create(_: CreateContent) throws {}
}
