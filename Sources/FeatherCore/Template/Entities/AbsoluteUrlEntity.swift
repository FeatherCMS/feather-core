//
//  AbsoluteUrlEntity.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 16..
//

struct AbsoluteUrlEntity: NonMutatingMethod, Invariant, StringReturn {

    static var callSignature: [CallParameter] { [.string] }
    
    func evaluate(_ params: CallValues) -> TemplateData {
        .string(Application.baseUrl + params[0].string!.safePath())
    }
}
