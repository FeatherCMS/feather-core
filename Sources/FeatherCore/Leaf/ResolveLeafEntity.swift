//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

public struct ResolveLeafEntity: LeafUnsafeEntity, LeafNonMutatingMethod, StringReturn {
    public var unsafeObjects: UnsafeObjects? = nil
    
    public static var callSignature: [LeafCallParameter] { [.string] }
    
    public init() {}

    public func evaluate(_ params: LeafCallValues) -> LeafData {
        guard let req = req else { return .error("Needs unsafe access to Request") }

        return .string(req.fs.resolve(key: params[0].string!))
    }
}
