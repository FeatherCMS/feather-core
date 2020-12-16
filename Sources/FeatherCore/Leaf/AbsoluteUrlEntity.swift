//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 16..
//

public struct AbsoluteUrlEntity: LeafNonMutatingMethod, Invariant, StringReturn {

    public static var callSignature: [LeafCallParameter] { [.string] }
    
    public init() {}

    public func evaluate(_ params: LeafCallValues) -> LeafData {
        .string(Application.baseUrl + params[0].string!.safePath())
    }
}
