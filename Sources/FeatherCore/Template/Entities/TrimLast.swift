//
//  RequestPathDropLast.swift
//  TauFoundation
//
//  Created by Tibor Bodecs on 2020. 10. 23..
//

/// split + dropLast + joined
struct TrimLast: NonMutatingMethod, Invariant, StringReturn {

    static var callSignature: [CallParameter] {
        [
            .string,
            .init(types: .int, optional: true, defaultValue: 1),
            .init(label: "separator", types: .string, optional: true, defaultValue: "/"),
        ]
    }

    func evaluate(_ params: CallValues) -> TemplateData {
        let path = params[0].string!
        let n = max(1, params[1].int!)
        let s = params[2].string!
        return .string(s + path.split(separator: .init(s)).dropLast(n).joined(separator: s) + s)
    }
}
