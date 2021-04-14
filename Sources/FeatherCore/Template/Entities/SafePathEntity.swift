//
//  SafePathEntity.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 14..
//

struct SafePathEntity: NonMutatingMethod, Invariant, StringReturn {

    static var callSignature: [CallParameter] { [.string] }
    
    func evaluate(_ params: CallValues) -> TemplateData {
        .string(params[0].string!.safePath())
    }
}

