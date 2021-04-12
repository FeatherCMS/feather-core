//
//  GetContentRepresentable.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 25..
//

public protocol GetContentRepresentable {
    associatedtype GetContent: Content

    var getContent: GetContent { get }
}
