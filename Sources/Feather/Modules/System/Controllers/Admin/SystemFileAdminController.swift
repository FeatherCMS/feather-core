//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 03. 04..
//

import Vapor
import FeatherApi

struct SystemFileAdminController: SystemFileController {

    func listView(_ req: Request) async throws -> Response {
        guard try await listFileAccess(req) else {
            throw Abort(.forbidden)
        }
        let list = try await list(req)
        let template = SystemFileBrowserTemplate(.init(list: list))
        return req.templates.renderHtml(template)
    }
    
    // MARK: - create directory
    
    private func renderCreateDirectoryView(_ req: Request, form: AbstractForm) -> Response {
        let template = SystemFileCreateDirectoryTemplate(.init(form: form.context(req)))
        return req.templates.renderHtml(template)
    }
    
    func createDirectoryView(_ req: Request) async throws -> Response {
        guard try await createFileAccess(req) else {
            throw Abort(.forbidden)
        }
        let form = SystemFileCreateDirectoryForm()
        form.fields = form.createFields(req)
        try await form.load(req: req)
        return renderCreateDirectoryView(req, form: form)
    }
    
    func createDirectoryAction(_ req: Request) async throws -> Response {
        guard try await createFileAccess(req) else {
            throw Abort(.forbidden)
        }
        let form = SystemFileCreateDirectoryForm()
        form.fields = form.createFields(req)
        try await form.load(req: req)
        try await form.process(req: req)
        let isValid = try await form.validate(req: req)
        guard isValid else {
            return renderCreateDirectoryView(req, form: form)
        }
        try await form.read(req: req)
        let key = req.query["path"] ?? ""
        let queryString = key.isEmpty ? "" : "?path=\(key)"
        /// remove leading and trailing / after safePath call
        let directoryKey = String((key + "/" + form.name).safePath().dropFirst().dropLast())
        try await req.fs.createDirectory(key: directoryKey)
        return req.redirect(to: "/admin/system/files/" + queryString)
    }

    // MARK: - upload
    
    private func renderUploadView(_ req: Request, form: AbstractForm) -> Response {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .binary
        let byteCount = req.application.routes.defaultMaxBodySize
        let maxUploadSize = formatter.string(fromByteCount: Int64(byteCount.value))
        
        let template = SystemFileUploadTemplate(.init(maxUploadSize: maxUploadSize, form: form.context(req)))
        return req.templates.renderHtml(template)
    }
    
    func uploadView(_ req: Request) async throws -> Response {
        guard try await createFileAccess(req) else {
            throw Abort(.forbidden)
        }
        let form = SystemFileUploadForm()
        form.fields = form.createFields(req)
        try await form.load(req: req)
        return renderUploadView(req, form: form)
    }
    
    func uploadAction(_ req: Request) async throws -> Response {
        guard try await createFileAccess(req) else {
            throw Abort(.forbidden)
        }
        let form = SystemFileUploadForm()
        form.fields = form.createFields(req)
        try await form.process(req: req)
        let isValid = try await form.validate(req: req)
        guard isValid else {
            return renderUploadView(req, form: form)
        }
        try await form.read(req: req)
        let key = req.query["path"] ?? ""
        let queryString = key.isEmpty ? "" : "?path=\(key)"
        try await form.files.forEachAsync { file  in
            let fileKey = String((key + "/" + file.filename).safePath().dropFirst())
            _ = try await req.fs.upload(key: fileKey, data: file.byteBuffer.data!)
        }
        return req.redirect(to: "/admin/system/files/" + queryString)
    }
    
    // MARK: - delete
    
    func deleteView(_ req: Request) async throws -> Response {
        guard try await deleteFileAccess(req) else {
            throw Abort(.forbidden)
        }
        var key: String? = nil
        var exists: Bool = true
        if let keyValue = try? req.query.get(String.self, at: "path"), !keyValue.isEmpty {
            key = keyValue
            exists = await req.fs.exists(key: keyValue)
        }
        guard exists else {
            throw Abort(.notFound)
        }
        
        let form = DeleteForm()
        /// generate nonce token
        try await form.load(req: req)
        let template = SystemAdminDeletePageTemplate(.init(title: "Delete file",
                                                           name: key ?? "",
                                                           type: "file",
                                                           form: form.context(req)))
        return req.templates.renderHtml(template)
    }
    
    func deleteAction(_ req: Request) async throws -> Response {
        guard try await deleteFileAccess(req) else {
            throw Abort(.forbidden)
        }
        let form = DeleteForm()
        /// validate nonce token
        let isValid = try await form.validate(req: req)
        guard isValid else {
            throw Abort(.badRequest)
        }
        
        if let keyValue = try? req.query.get(String.self, at: "path"), !keyValue.isEmpty {
            try await req.fs.delete(key: keyValue)
        }

        var url = "/admin/system/files/"
        if let redirect = try? req.query.get(String.self, at: "redirect") {
            url = redirect
        }
        return req.redirect(to: url)
    }
    
    func setUpRoutes(_ routes: RoutesBuilder) {
        let moduleRoutes = routes.grouped(FeatherSystem.pathKey.pathComponent)
        moduleRoutes.get("files", use: listView)

        let filesRoutes = moduleRoutes.grouped("files")

        filesRoutes.get("directory", use: createDirectoryView)
        filesRoutes.post("directory", use: createDirectoryAction)

        filesRoutes.get("upload", use: uploadView)
        filesRoutes.post("upload", use: uploadAction)

        filesRoutes.get("delete", use: deleteView)
        filesRoutes.post("delete", use: deleteAction)
    }
}
