//
//  IntMinEntity.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 16..
//

struct IntMinEntity: NonMutatingMethod, Invariant, IntReturn {

    static var callSignature: [CallParameter] { [.int, .int] }

    func evaluate(_ params: CallValues) -> TemplateData {
        .int(min(params[0].int!, params[1].int!))
    }
}
