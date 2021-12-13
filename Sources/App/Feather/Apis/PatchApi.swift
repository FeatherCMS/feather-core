//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor

public protocol PatchApi: ModelApi {
    
    associatedtype PatchObject: Content
    
    func patchValidators() -> [AsyncValidator]
    func mapPatch(_ req: Request, model: Model, input: PatchObject) async
}

public extension PatchApi {

    func patchValidators() -> [AsyncValidator] {
        []
    }

}
