//
//  RequestQuery.swift
//  TauFoundation
//
//  Created by Tibor Bodecs on 2020. 10. 23..
//

struct RequestQuery: UnsafeEntity, StringReturn {

    var unsafeObjects: UnsafeObjects? = nil
    
    static var callSignature: [CallParameter] { [.string(labeled: "query")] }
    
    func evaluate(_ params: CallValues) -> TemplateData {
        guard let req = req else { return .error("Needs unsafe access to Request") }
        return .string(req.query[params[0].string!])
    }
}
