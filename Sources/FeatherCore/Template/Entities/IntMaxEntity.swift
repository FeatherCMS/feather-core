//
//  IntMaxEntity.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 16..
//

public struct IntMaxEntity: NonMutatingMethod, Invariant, IntReturn {

    public static var callSignature: [CallParameter] { [.int, .int] }
    
    public init() {}

    public func evaluate(_ params: CallValues) -> TemplateData {
        .int(max(params[0].int!, params[1].int!))
    }
}
