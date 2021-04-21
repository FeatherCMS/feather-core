//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 16..
//

public struct ModelInfo: Encodable {

    public struct ModelName: Encodable {
        let singular: String
        let plural: String
    }

    public struct AvailablePermissions: Encodable {
        let list: Bool
        let get: Bool
        let create: Bool
        let update: Bool
        let patch: Bool
        let delete: Bool
    }
    
    public struct ModuleInfo: Encodable {
        let idKey: String
        let name: String
        let assetPath: String
    }

    let idKey: String
    let idParamKey: String
    let name: ModelName
    let assetPath: String
    let module: ModuleInfo
    let permissions: AvailablePermissions
    let isSearchable: Bool
    let allowedOrders: [String]
    let defaultOrder: String?
    let defaultSort: String
}
