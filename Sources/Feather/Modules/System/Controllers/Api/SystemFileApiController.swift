//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 03. 04..
//

import FeatherApi

struct SystemFileApiController {
            
//    func listApi(_ req: Request) async throws -> SystemFile.List {
//        try await list(req)
//    }
//
//    func createDirectoryApi(_ req: Request) async throws -> HTTPStatus {
//        let input = try req.content.decode(SystemFile.Directory.Create.self)
//        let directoryKey = String(((input.key ?? "") + "/" + input.name).safePath().dropFirst().dropLast())
//        try await req.fs.createDirectory(key: directoryKey)
//        return .noContent
//    }
    
    private func getValidFileName(_ name: String, _ ext: String, existing: [String]) -> String {
        let fullName = name + "." + ext
        guard existing.contains(fullName) else {
            return name
        }
        
        let baseNames = existing
            // remove existing file from the array
            .filter { $0 != fullName }
            // remove non matching extensions
            .filter { $0.hasSuffix("." + ext) }
            // drop extensions
            .map { String($0.dropLast(ext.count + 1)) }
        
        let numbers = baseNames
            // remove non-matching file names
            .filter { $0.hasPrefix(name + "_") }
            // drop file name prefixes
            .map { String($0.dropFirst(name.count + 1)) }
            .compactMap { Int($0) }

        let n = numbers.sorted().last ?? 0
      
        return name + "_" + String(n + 1)
    }
    
    func uploadApi(_ req: Request) async throws -> FeatherFile {
        try await RequestValidator([
            KeyedQueryValidator<String>.required("path"),
            KeyedQueryValidator<String>.required("ext"),
        ]).validate(req)
        
        let path = try req.query.get(String.self, at: "path")
        let name = try? req.query.get(String.self, at: "name")
        let ext = try req.query.get(String.self, at: "ext")
        
        // @NOTE: use max value to limit file uploads?
        guard
            let body = try await req.body.collect().get(),
            let data = body.getData(at: 0, length: body.readableBytes)
        else {
            throw Abort(.badRequest)
        }
        
        var finalName: String = UUID().uuidString
        if let possibleName = name {
            let dir = try await req.fs.list(key: path)
            finalName = getValidFileName(possibleName, ext, existing: dir)
        }

        let fileKey = String((path + "/" + finalName + "." + ext).safePath().dropFirst())
        _ = try await req.fs.upload(key: fileKey, data: data)
        return .init(path: path, name: finalName, ext: ext)
    }
    
    func deleteApi(_ req: Request) async throws -> HTTPStatus {
        let key = try req.query.get(String.self, at: "key")
        _ = try await req.fs.delete(key: key)
        return .noContent
    }
    
    func setUpRoutes(_ routes: RoutesBuilder) {
        let group = routes
            .grouped(FeatherSystem.pathKey.pathComponent)
            .grouped(FeatherFile.pathKey.pathComponent)
        
        group.post(use: uploadApi)
        
//        let moduleRoutes = args.routes.grouped(System.pathKey.pathComponent)
//        moduleRoutes.get("files", use: fileApiController.listApi)
//        moduleRoutes.post("files", use: fileApiController.uploadApi)
//        moduleRoutes.delete("files", use: fileApiController.deleteApi)
//        
//        let filesRoutes = moduleRoutes.grouped("files")
//        filesRoutes.post("directory", use: fileApiController.createDirectoryApi)
    }
}

