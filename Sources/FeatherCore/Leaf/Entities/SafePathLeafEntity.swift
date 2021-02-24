//
//  SafePathLeafEntity.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 14..
//

public struct SafePathLeafEntity: LeafNonMutatingMethod, Invariant, StringReturn {

    public static var callSignature: [LeafCallParameter] { [.string] }
    
    public init() {}

    public func evaluate(_ params: LeafCallValues) -> LeafData {
        .string(params[0].string!.safePath())
    }
}

