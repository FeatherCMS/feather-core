//
//  ListContentRepresentable.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol ListContentRepresentable {
    associatedtype ListItem: Content

    var listContent: ListItem { get }
}

