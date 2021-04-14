//
//  ResolveEntity.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

struct ResolveEntity: UnsafeEntity, NonMutatingMethod, StringReturn {
    
    var unsafeObjects: UnsafeObjects? = nil
    
    static var callSignature: [CallParameter] { [.string] }
    
    func evaluate(_ params: CallValues) -> TemplateData {
        guard let req = req else { return .error("Needs unsafe access to Request") }

        return .string(req.fs.resolve(key: params[0].string!))
    }
}
