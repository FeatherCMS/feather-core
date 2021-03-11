//
//  AbsoluteUrlEntity.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 16..
//

public struct AbsoluteUrlEntity: NonMutatingMethod, Invariant, StringReturn {

    public static var callSignature: [CallParameter] { [.string] }
    
    public init() {}

    public func evaluate(_ params: CallValues) -> TemplateData {
        .string(Application.baseUrl + params[0].string!.safePath())
    }
}
