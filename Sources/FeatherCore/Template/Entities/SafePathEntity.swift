//
//  SafePathEntity.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 14..
//

public struct SafePathEntity: NonMutatingMethod, Invariant, StringReturn {

    public static var callSignature: [CallParameter] { [.string] }
    
    public init() {}

    public func evaluate(_ params: CallValues) -> TemplateData {
        .string(params[0].string!.safePath())
    }
}

