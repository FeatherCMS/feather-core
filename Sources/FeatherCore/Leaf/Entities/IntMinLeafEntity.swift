//
//  IntMinLeafEntity.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 16..
//


public struct IntMinLeafEntity: LeafNonMutatingMethod, Invariant, IntReturn {

    public static var callSignature: [LeafCallParameter] { [.int, .int] }
    
    public init() {}

    public func evaluate(_ params: LeafCallValues) -> LeafData {
        .int(min(params[0].int!, params[1].int!))
    }
}
