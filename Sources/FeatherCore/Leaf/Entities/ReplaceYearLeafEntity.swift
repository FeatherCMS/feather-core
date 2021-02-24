//
//  ReplaceYearLeafEntity.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2021. 02. 24..
//

import Foundation

public struct ReplaceYearLeafEntity: LeafFunction, Invariant, LeafNonMutatingMethod, StringReturn {

    public static var callSignature: [LeafCallParameter] { [.string] }
    
    public init() {}

    public func evaluate(_ params: LeafCallValues) -> LeafData {
        let input = params[0].string!
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let year = calendar.component(.year, from: now)
        return .string(input.replacingOccurrences(of: "{year}", with: "\(year)"))
    }
}
