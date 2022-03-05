//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

import FeatherApi

public struct SystemPermissionApi {

    private let repository: SystemPermissionRepository
    
    init(_ repository: SystemPermissionRepository) {
        self.repository = repository
    }
}

public extension SystemPermissionApi {

    func list() async throws -> [FeatherPermission.List] {
        try await repository.list().transform(to: [FeatherPermission.List].self)
    }
    
    func list(_ ids: [UUID]) async throws -> [FeatherPermission.List] {
        try await repository.get(ids).transform(to: [FeatherPermission.List].self)
    }
    
    func get(_ id: UUID) async throws -> FeatherPermission.Detail? {
        try await repository.get(id)?.transform(to: FeatherPermission.Detail.self)
    }
    
    func get(_ key: String) async throws -> FeatherPermission.Detail? {
        try await repository.get(key)?.transform(to: FeatherPermission.Detail.self)
    }

    func get(_ ids: [UUID]) async throws -> [FeatherPermission.Detail] {
        try await repository.get(ids).transform(to: [FeatherPermission.Detail].self)
    }

    func optionList() async throws -> [OptionContext] {
        try await list().map { .init(key: $0.id.string, label: $0.name) }
    }
    
    func getOptionBundles() async throws -> [OptionBundleContext] {
        var data: [OptionBundleContext] = []
        for permission in try await list() {
            let ffo = OptionContext(key: permission.id.string, label: permission.action.capitalized)
            let module = permission.namespace.capitalized

            /// if there is no module with the permission, we create it...
            var moduleIndex: Array<OptionGroupContext>.Index!
            if let i = data.firstIndex(where: { $0.name == module }) {
                moduleIndex = i
            }
            else {
                data.append(OptionBundleContext(name: module))
                moduleIndex = data.endIndex.advanced(by: -1)
            }

            let ctx = permission.context.replacingOccurrences(of: ".", with: " ").capitalized
            /// find an existing ctx group or create a new one...
            var groupIndex: Array<OptionGroupContext>.Index!
            if let g = data[moduleIndex].groups.firstIndex(where: { $0.name == ctx }) {
                groupIndex = g
            }
            else {
                data[moduleIndex].groups.append(.init(name: ctx))
                groupIndex = data[moduleIndex].groups.endIndex.advanced(by: -1)
            }
            data[moduleIndex].groups[groupIndex].options.append(ffo)
        }
        return data
    }
    
    func isUnique(_ permission: FeatherPermission) async throws -> Bool {
        try await repository.isUnique(permission)
    }
}
