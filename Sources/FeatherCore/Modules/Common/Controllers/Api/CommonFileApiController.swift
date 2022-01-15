//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

struct CommonFileApiController: CommonFileController {

    func listApi(_ req: Request) async throws -> CommonFile.List {
        try await list(req)
    }

    func createDirectoryApi(_ req: Request) async throws -> HTTPStatus {
        let input = try req.content.decode(CommonFile.Directory.Create.self)
        let directoryKey = String(((input.key ?? "") + "/" + input.name).safePath().dropFirst().dropLast())
        try await req.fs.createDirectory(key: directoryKey)
        return .noContent
    }
    
    func uploadApi(_ req: Request) async throws -> HTTPStatus {
        let key = try req.query.get(String.self, at: "key")
        let name = try req.query.get(String.self, at: "name")

        // @NOTE: use max value to limit file uploads?
        guard
            let body = try await req.body.collect().get(),
            let data = body.getData(at: 0, length: body.readableBytes)
        else {
            throw Abort(.badRequest)
        }

        let fileKey = String((key + "/" + name).safePath().dropFirst())
        _ = try await req.fs.upload(key: fileKey, data: data)
        return .ok
    }
    
    func deleteApi(_ req: Request) async throws -> HTTPStatus {
        let key = try req.query.get(String.self, at: "key")
        _ = try await req.fs.delete(key: key)
        return .noContent
    }
}
