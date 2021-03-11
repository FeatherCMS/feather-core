//
//  ReplaceYearEntity.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2021. 02. 24..
//

import Foundation

public struct ReplaceYearEntity: Function, Invariant, NonMutatingMethod, StringReturn {

    public static var callSignature: [CallParameter] { [.string] }
    
    public init() {}

    public func evaluate(_ params: CallValues) -> TemplateData {
        let input = params[0].string!
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let year = calendar.component(.year, from: now)
        return .string(input.replacingOccurrences(of: "{year}", with: "\(year)"))
    }
}
