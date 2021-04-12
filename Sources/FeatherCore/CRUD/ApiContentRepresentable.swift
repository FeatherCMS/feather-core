//
//  ApiRepresentable.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

public protocol ApiContentRepresentable: ListContentRepresentable,
    // silence redundant conformance warning
    //GetContentRepresentable,
    CreateContentRepresentable,
    UpdateContentRepresentable,
    PatchContentRepresentable,
    DeleteContentRepresentable
{
    
}
