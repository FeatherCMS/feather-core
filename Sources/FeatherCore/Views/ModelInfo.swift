//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 16..
//

public struct ModelInfo: Encodable {

    public struct AvailablePermissions: Encodable {
        let list: Bool
        let get: Bool
        let create: Bool
        let update: Bool
        let patch: Bool
        let delete: Bool
    }

    public struct Urls: Encodable {
        let list: String
    }
    
    public struct ModuleInfo: Encodable {
        let key: String
        let title: String
        let path: String
    }

    let key: String
    let title: String
    let module: ModuleInfo
    let permissions: AvailablePermissions
    let urls: Urls
}
