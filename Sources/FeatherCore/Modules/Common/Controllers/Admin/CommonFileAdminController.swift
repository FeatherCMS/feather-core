//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 22..
//

struct CommonFileAdminController: CommonFileController {

    func listView(_ req: Request) async throws -> Response {
        let list = try await list(req)
        let template = CommonFileBrowserTemplate(.init(list: list))
        return req.templates.renderHtml(template)
    }
    
    // MARK: - create directory
    
    private func renderCreateDirectoryView(_ req: Request, form: AbstractForm) -> Response {
        let template = CommonFileCreateDirectoryTemplate(.init(form: form.context(req)))
        return req.templates.renderHtml(template)
    }
    
    func createDirectoryView(_ req: Request) async throws -> Response {
        let form = CommonFileCreateDirectoryForm()
        try await form.load(req: req)
        return renderCreateDirectoryView(req, form: form)
    }
    
    func createDirectoryAction(_ req: Request) async throws -> Response {
        let form = CommonFileCreateDirectoryForm()
        try await form.load(req: req)
        try await form.process(req: req)
        let isValid = try await form.validate(req: req)
        guard isValid else {
            return renderCreateDirectoryView(req, form: form)
        }
        try await form.read(req: req)
        let key = req.query["key"] ?? ""
        let queryString = key.isEmpty ? "" : "?key=\(key)"
        /// remove leading and trailing / after safePath call
        let directoryKey = String((key + "/" + form.name).safePath().dropFirst().dropLast())
        try await req.fs.createDirectory(key: directoryKey)
        return req.redirect(to: "/admin/common/files/" + queryString)
    }

    // MARK: - upload
    
    private func renderUploadView(_ req: Request, form: AbstractForm) -> Response {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .binary
        let byteCount = req.application.routes.defaultMaxBodySize
        let maxUploadSize = formatter.string(fromByteCount: Int64(byteCount.value))
        
        let template = CommonFileUploadTemplate(.init(maxUploadSize: maxUploadSize, form: form.context(req)))
        return req.templates.renderHtml(template)
    }
    
    func uploadView(_ req: Request) async throws -> Response {
        let form = CommonFileUploadForm()
        try await form.load(req: req)
        return renderUploadView(req, form: form)
    }
    
    func uploadAction(_ req: Request) async throws -> Response {
        let form = CommonFileUploadForm()
        try await form.process(req: req)
        let isValid = try await form.validate(req: req)
        guard isValid else {
            return renderUploadView(req, form: form)
        }
        try await form.read(req: req)
        let key = req.query["key"] ?? ""
        let queryString = key.isEmpty ? "" : "?key=\(key)"
        try await form.files.forEachAsync { file  in
            let fileKey = String((key + "/" + file.filename).safePath().dropFirst())
            _ = try await req.fs.upload(key: fileKey, data: file.byteBuffer.data!)
        }
        return req.redirect(to: "/admin/common/files/" + queryString)
    }
    
    // MARK: - delete
    
    func deleteView(_ req: Request) async throws -> Response {
        var key: String? = nil
        var exists: Bool = true
        if let keyValue = try? req.query.get(String.self, at: "key"), !keyValue.isEmpty {
            key = keyValue
            exists = await req.fs.exists(key: keyValue)
        }
        guard exists else {
            throw Abort(.notFound)
        }
        
        let form = DeleteForm()
        /// generate nonce token
        try await form.load(req: req)
        let template = AdminDeletePageTemplate(.init(title: "Delete file",
                                                     name: key ?? "",
                                                     type: "file",
                                                     form: form.context(req)))
        return req.templates.renderHtml(template)
    }
    
    func deleteAction(_ req: Request) async throws -> Response {
//        let hasAccess = try await deleteAccess(req)
//        guard hasAccess else {
//            throw Abort(.forbidden)
//        }
        let form = DeleteForm()
        /// validate nonce token
        let isValid = try await form.validate(req: req)
        guard isValid else {
            throw Abort(.badRequest)
        }
        
        if let keyValue = try? req.query.get(String.self, at: "key"), !keyValue.isEmpty {
            try await req.fs.delete(key: keyValue)
        }

        var url = "/admin/common/files/"
        if let redirect = try? req.query.get(String.self, at: "redirect") {
            url = redirect
        }
        return req.redirect(to: url)
    }
}
