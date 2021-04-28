//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 16..
//

public struct ModelInfo: Encodable {
    
    public struct ModelName: Encodable {
        public let singular: String
        public let plural: String
        
        public init(singular: String, plural: String) {
            self.singular = singular
            self.plural = plural
        }
    }

    public struct AvailablePermissions: Encodable {
        public let list: Bool
        public let get: Bool
        public let create: Bool
        public let update: Bool
        public let patch: Bool
        public let delete: Bool
        
        public init(list: Bool, get: Bool, create: Bool, update: Bool, patch: Bool, delete: Bool) {
            self.list = list
            self.get = get
            self.create = create
            self.update = update
            self.patch = patch
            self.delete = delete
        }
    }
    
    public struct ModuleInfo: Encodable {
        public let idKey: String
        public let name: String
        public let assetPath: String
        
        public init(idKey: String, name: String, assetPath: String) {
            self.idKey = idKey
            self.name = name
            self.assetPath = assetPath
        }
    }

    public let idKey: String
    public let idParamKey: String
    public let name: ModelName
    public let assetPath: String
    public let module: ModuleInfo
    public let permissions: AvailablePermissions
    public let isSearchable: Bool
    public let allowedOrders: [String]
    public let defaultOrder: String?
    public let defaultSort: String
    
    public init(idKey: String,
                idParamKey: String,
                name: ModelInfo.ModelName,
                assetPath: String,
                module: ModelInfo.ModuleInfo,
                permissions: ModelInfo.AvailablePermissions,
                isSearchable: Bool,
                allowedOrders: [String],
                defaultOrder: String?,
                defaultSort: String) {
        self.idKey = idKey
        self.idParamKey = idParamKey
        self.name = name
        self.assetPath = assetPath
        self.module = module
        self.permissions = permissions
        self.isSearchable = isSearchable
        self.allowedOrders = allowedOrders
        self.defaultOrder = defaultOrder
        self.defaultSort = defaultSort
    }
}
