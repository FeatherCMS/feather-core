//
//  ReplaceYearEntity.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2021. 02. 24..
//

struct ReplaceYearEntity: Function, Invariant, NonMutatingMethod, StringReturn {

    static var callSignature: [CallParameter] { [.string] }

    func evaluate(_ params: CallValues) -> TemplateData {
        let input = params[0].string!
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let year = calendar.component(.year, from: now)
        return .string(input.replacingOccurrences(of: "{year}", with: "\(year)"))
    }
}
