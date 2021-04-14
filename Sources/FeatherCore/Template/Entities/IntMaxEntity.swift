//
//  IntMaxEntity.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 16..
//

struct IntMaxEntity: NonMutatingMethod, Invariant, IntReturn {

    static var callSignature: [CallParameter] { [.int, .int] }

    func evaluate(_ params: CallValues) -> TemplateData {
        .int(max(params[0].int!, params[1].int!))
    }
}
