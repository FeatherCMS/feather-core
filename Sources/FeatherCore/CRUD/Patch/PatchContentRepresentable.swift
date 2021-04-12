//
//  PatchContentRepresentable.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 25..
//

public protocol PatchContentRepresentable: GetContentRepresentable {
    associatedtype PatchContent: ValidatableContent

    func patch(_: PatchContent) throws
}

public extension PatchContentRepresentable {
    func patch(_: PatchContent) throws {}
}
