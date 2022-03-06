//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 03. 04..
//

import Vapor
import FeatherApi

extension FeatherFile.List: Content {}

extension String {
    var fileExt: String? {
        guard contains(".") else {
            return nil
        }
        return split(separator: ".").last.map(String.init)
    }
}

protocol SystemFileController {

    func listFileAccess(_ req: Request) async throws -> Bool
    func createFileAccess(_ req: Request) async throws -> Bool
    func deleteFileAccess(_ req: Request) async throws -> Bool
        
    func list(_ req: Request) async throws -> FeatherFile.List
}

extension SystemFileController {
    
    func listFileAccess(_ req: Request) async throws -> Bool {
        try await req.checkAccess(for: FeatherFile.permission(for: .list))
    }

    func createFileAccess(_ req: Request) async throws -> Bool {
        try await req.checkAccess(for: FeatherFile.permission(for: .create))
    }
    
    func deleteFileAccess(_ req: Request) async throws -> Bool {
        try await req.checkAccess(for: FeatherFile.permission(for: .delete))
    }
    
    func list(_ req: Request) async throws -> FeatherFile.List {
        guard try await listFileAccess(req) else {
            throw Abort(.forbidden)
        }
        var currentKey: String? = nil
        var exists = true
        if let rawPath = try? req.query.get(String.self, at: "path"), !rawPath.isEmpty {
            exists = await req.fs.exists(key: rawPath)
            currentKey = rawPath
        }
        guard exists else {
            throw Abort(.notFound)
        }

        let children = try await req.fs.list(key: currentKey)
            .map { key -> FeatherFile.List.Item in
                var fileKey = key
                if let parentPath = currentKey, !parentPath.isEmpty {
                    fileKey = parentPath + "/" + key
                }
                return .init(path: fileKey, name: key, ext: key.fileExt)
            }
            .filter { !($0.name == "tmp" && $0.ext == nil) && !$0.name.hasPrefix(".") }
            .sorted { lhs, rhs -> Bool in
                if lhs.ext != nil {
                    return false
                }
                if rhs.ext != nil {
                    return true
                }
                return lhs.path < rhs.path
            }

        var current: FeatherFile.List.Item?
        var parent: FeatherFile.List.Item?
        if let currentKey = currentKey, !currentKey.isEmpty {
            let currentName = String(currentKey.split(separator: "/").last!)
            current = .init(path: currentKey, name: currentName, ext: currentKey.fileExt)
            let parentKey = currentKey.split(separator: "/").dropLast().joined(separator: "/")
            parent = .init(path: parentKey, name: parentKey, ext: parentKey.fileExt)
        }
        return .init(current: current, parent: parent, children: children)
    }
}
