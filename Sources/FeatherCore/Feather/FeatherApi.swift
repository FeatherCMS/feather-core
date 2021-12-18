//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Foundation

public protocol FeatherApi: ListApi,
                            DetailApi,
                            CreateApi,
                            UpdateApi,
                            PatchApi,
                            DeleteApi
{
    func validators(optional: Bool) -> [AsyncValidator]
}

public extension FeatherApi {

    func createValidators() -> [AsyncValidator] {
        validators(optional: false)
    }

    func updateValidators() -> [AsyncValidator] {
        validators(optional: false)
    }

    func patchValidators() -> [AsyncValidator] {
        validators(optional: true)
    }
}
