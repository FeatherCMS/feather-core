//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//

struct CommonFileController {

    struct BrowserFiles: Codable {
        let current: FileItem?
        let parent: FileItem?
        let children: [FileItem]
    }

    struct FileItem: Codable {
        let name: String
        let key: String
        let ext: String?
    }
    
    func browserView(req: Request) -> EventLoopFuture<Response> {
        var key: String? = nil
        /// if there is a key, check if it exists
        var future: EventLoopFuture<Bool> = req.eventLoop.future(true)
        if let rawPath = try? req.query.get(String.self, at: "key"), !rawPath.isEmpty {
            future = req.fs.exists(key: rawPath)
            key = rawPath
        }
        
        /// check if directory exists, then make some assumption about the list items...
        return future.flatMap { exists -> EventLoopFuture<Response> in
            guard exists else {
                return req.eventLoop.future(error: Abort(.notFound))
            }
            return req.fs.list(key: key).mapEach { name -> FileItem in
                var filePath = name
                /// we append the parent location key to the file key if needed
                if let currentPath = key, !currentPath.isEmpty {
                    filePath = currentPath + "/" + filePath
                }
                return FileItem(name: name, key: filePath, ext: name.fileExt)
            }
            .flatMap { children -> EventLoopFuture<View> in
                var current: FileItem?
                var parent: FileItem?
                if let currentKey = key, !currentKey.isEmpty {
                    let currentName = String(currentKey.split(separator: "/").last!)
                    current = FileItem(name: currentName, key: currentKey, ext: currentKey.fileExt)
                    
                    let parentKey = currentKey.split(separator: "/").dropLast().joined(separator: "/")
                    parent = FileItem(name: parentKey, key: parentKey, ext: parentKey.fileExt)
                }
                
                let sortedChildren = children.sorted { lhs, rhs -> Bool in
                    if lhs.ext != nil {
                        return false
                    }
                    if rhs.ext != nil {
                        return true
                    }
                    return lhs.key < rhs.key
                }
                /// filter tmp folder and hidden files & directories
                .filter { !($0.name == "tmp" && $0.ext == nil) && !$0.name.hasPrefix(".") }

                return req.view.render("Common/Admin/File/Browser", BrowserFiles(current: current, parent: parent, children: sortedChildren))
            }
            .encodeResponse(for: req)
        }
    }

    private func renderDirectoryView(req: Request, form: CommonFileDirectoryForm) -> EventLoopFuture<View> {
        return form.load(req: req).flatMap {
            return req.view.render("Common/Admin/File/Directory", ["form": form])
        }
    }
    
    func directoryView(req: Request) -> EventLoopFuture<View> {
        let form = CommonFileDirectoryForm()
        return renderDirectoryView(req: req, form: form)
    }
    
    func directory(req: Request) throws -> EventLoopFuture<Response> {
        let form = CommonFileDirectoryForm()
        return form.process(req: req)
            .flatMap { form.validate(req: req) }
            .flatMap { isValid in
                guard isValid else {
                    return renderDirectoryView(req: req, form: form).encodeResponse(for: req)
                }
                return form.read(req: req).flatMap {
                    let key = req.query["key"] ?? ""
                    let queryString = key.isEmpty ? "" : "?key=\(key)"
                    /// remove leading and trailing / after safePath call
                    let directoryKey = String((key + "/" + form.name).safePath().dropFirst().dropLast())
                    return req.fs.createDirectory(key: directoryKey).map {
                        req.redirect(to: "/admin/common/files/" + queryString)
                    }
                }
            }
    }
    
    // MARK: - upload
    
    private func renderUploadView(req: Request, form: CommonFileUploadForm) -> EventLoopFuture<View> {
        /// provide max upload size for the template
        let formatter = ByteCountFormatter()
        formatter.countStyle = .binary
        let byteCount = req.application.routes.defaultMaxBodySize
        let maxUploadSize = formatter.string(fromByteCount: Int64(byteCount.value))

        struct Context: Encodable {
            let form: CommonFileUploadForm
            let maxUploadSize: String
        }
        
        return form.load(req: req).flatMap {
            req.view.render("Common/Admin/File/Upload", Context(form: form, maxUploadSize: maxUploadSize))
        }
    }
    
    func uploadView(req: Request) -> EventLoopFuture<View> {
        renderUploadView(req: req, form: .init())
    }
    
    func upload(req: Request) throws -> EventLoopFuture<Response> {

        let form = CommonFileUploadForm()
        return form.process(req: req)
            .flatMap { form.validate(req: req) }
            .flatMap { [self] isValid in
                guard isValid else {
                    return renderUploadView(req: req, form: form).encodeResponse(for: req)
                }
                return form.read(req: req).flatMap {
                    print(form.files)
                    return renderUploadView(req: req, form: form).encodeResponse(for: req)
                }


//                let futures = form.files.values.map { file -> EventLoopFuture<String> in
//                    /// NOTE: better key validation on long term...
//                    let fileKey = String((form.key.value! + "/" + file.filename).safePath().dropFirst())
//                    return req.fs.upload(key: fileKey, data: file.dataValue!)
//                }
//                return req.eventLoop.flatten(futures).flatMap { _ in
//                    req.redirect(to: "/admin/file/browser/?key=\(form.key.value!)").encodeResponse(for: req)
//                }
            }
    }
    
    // MARK: - delete
    
//    func deleteView(req: Request) throws -> EventLoopFuture<Response>  {
//        let formId = UUID().uuidString
//        let nonce = req.generateNonce(for: "file-delete-form", id: formId)
//
//        var key: String? = nil
//        /// if there is a key, check if it exists
//        var future: EventLoopFuture<Bool> = req.eventLoop.future(true)
//        if let keyValue = try? req.query.get(String.self, at: "key"), !keyValue.isEmpty {
//            future = req.fs.exists(key: keyValue)
//            key = keyValue
//        }
//
//        /// check if directory exists, then make some assumption about the list items...
//        return future.flatMap { exists -> EventLoopFuture<Response> in
//            guard exists else {
//                return req.eventLoop.future(error: Abort(.notFound))
//            }
//            return req.tau.render(template: "File/Admin/Delete", context: [
//                "formId": .string(formId),
//                "formToken": .string(nonce),
//                "name": .string(key),
//            ]).encodeResponse(for: req)
//        }
//    }
//
//    func delete(req: Request) throws -> EventLoopFuture<Response> {
//        try req.validateFormToken(for: "file-delete-form")
//
//        struct Context: Decodable {
//            let key: String
//            let redirect: String
//        }
//        let context = try req.content.decode(Context.self)
//        return req.fs.delete(key: context.key).flatMap {
//            req.redirect(to: context.redirect).encodeResponse(for: req)
//        }
//    }

    
}
