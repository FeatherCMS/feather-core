//
//  AdminController.swift
//  AdminModule
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

struct SystemAdminController {

    struct File: TemplateDataRepresentable {
        let name: String
        let key: String
        let ext: String?
        
        var templateData: TemplateData {
            .dictionary([
                "name": name,
                "key": key,
                "ext": ext,
            ])
        }
    }
    
    func homeView(req: Request) throws -> EventLoopFuture<View> {
        let menus: [[SystemMenu]] = req.invokeAll("admin-menus")
        return req.view.render("System/Admin/Home", [
            "menus": menus.flatMap { $0 }
        ])
    }
    
    func dashboardView(req: Request) throws -> EventLoopFuture<View> {
        return req.eventLoop.flatten([
            req.view.render("System/Admin/Widgets/Variables", ["name": "foo", "count": "15"])
        ])
        .mapEach { $0.data.getString(at: 0, length: $0.data.readableBytes) }
        .flatMap { items -> EventLoopFuture<View> in
            let widgets = items.compactMap { $0 }
            return req.view.render("System/Admin/Dashboard", ["widgets": widgets])
        }
    }
    
    func settingsView(req: Request) throws -> EventLoopFuture<View> {
        
        let formController = SystemSettingsForm()
        return formController.load(req: req)
            .flatMap { formController.read(req: req) }
            .flatMap { render(req: req, form: formController.context.form) }
    }

    func render(req: Request, form: Form) -> EventLoopFuture<View> {
        req.view.render("System/Admin/Settings", ["form": form])
    }
    
    func updateSettings(req: Request) throws -> EventLoopFuture<Response> {
//        try req.validateFormToken(for: "site-settings-form")

        let formController = SystemSettingsForm()
        return formController.load(req: req)
            .flatMap { formController.process(req: req) }
            .flatMap { formController.validate(req: req) }
            .throwingFlatMap { isValid in
                guard isValid else {
                    return render(req: req, form: formController.context.form)
                        .encodeResponse(for: req)
                }
                return formController.write(req: req)
                    .flatMap { formController.save(req: req) }
                    .map { req.redirect(to: "/admin/settings/") }
            }
    }
    
    // MARK: - file api
    
    
    func browserView(req: Request) -> EventLoopFuture<Response> {
        var key: String? = nil
        /// if there is a key, check if it exists
        var future: EventLoopFuture<Bool> = req.eventLoop.future(true)
        if let keyValue = try? req.query.get(String.self, at: "key"), !keyValue.isEmpty {
            future = req.fs.exists(key: keyValue)
            key = keyValue
        }
        
        /// check if directory exists, then make some assumption about the list items...
        return future.flatMap { exists -> EventLoopFuture<Response> in
            guard exists else {
                return req.eventLoop.future(error: Abort(.notFound))
            }
            return req.fs.list(key: key).mapEach { name -> File in
                var fileKey = name
                /// we append the parent location key to the file key if needed
                if let currentKey = key, !currentKey.isEmpty {
                    fileKey = currentKey + "/" + fileKey
                }
                return File(name: name, key: fileKey, ext: name.fileExt)
            }
            .flatMap { children -> EventLoopFuture<View> in
                var current: File?
                var parent: File?
                if let currentKey = key, !currentKey.isEmpty {
                    let currentName = String(currentKey.split(separator: "/").last!)
                    current = File(name: currentName, key: currentKey, ext: currentKey.fileExt)
                    
                    let parentKey = currentKey.split(separator: "/").dropLast().joined(separator: "/")
                    parent = File(name: parentKey, key: parentKey, ext: parentKey.fileExt)
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
                
                return req.tau.render(template: "File/Admin/Browser", context: [
                    "current": current?.templateData ?? .trueNil,
                    "parent": parent?.templateData ?? .trueNil,
                    "children": .array(sortedChildren),
                ])
            }
            .encodeResponse(for: req)
        }
    }
//    
//    private func renderDirectoryView(req: Request, form: FileDirectoryForm) -> EventLoopFuture<View> {
//        let formId = UUID().uuidString
//        let nonce = req.generateNonce(for: "file-directory-form", id: formId)
//        
//        var templateData = form.templateData.dictionary!
//        templateData["formId"] = .string(formId)
//        templateData["formToken"] = .string(nonce)
//        
//        return req.tau.render(template: "File/Admin/Directory", context: .init(templateData))
//    }
//    
//    func directoryView(req: Request) -> EventLoopFuture<View> {
//        renderDirectoryView(req: req, form: .init())
//    }
//    
//    func directory(req: Request) throws -> EventLoopFuture<Response> {
//        try req.validateFormToken(for: "file-directory-form")
//        
//        let form = FileDirectoryForm()
//        return form.initialize(req: req)
//            .flatMap { form.process(req: req) }
//            .flatMap { form.validate(req: req) }
//            .flatMap { [self] isValid in
//                guard isValid else {
//                    return renderDirectoryView(req: req, form: form).encodeResponse(for: req)
//                }
//                return form.save(req: req).map {
//                    req.redirect(to: "/admin/file/browser/?key=\(form.key.value!)")
//                }
//            }
//    }
//    
//    // MARK: - upload
//    
//    private func renderUploadView(req: Request, form: FileUploadForm) -> EventLoopFuture<View> {
//        let formId = UUID().uuidString
//        let nonce = req.generateNonce(for: "file-upload-form", id: formId)
//        
//        var templateData = form.templateData.dictionary!
//        templateData["formId"] = .string(formId)
//        templateData["formToken"] = .string(nonce)
//        
//        /// provide max upload size for the template
//        let formatter = ByteCountFormatter()
//        formatter.countStyle = .binary
//        let byteCount = req.application.routes.defaultMaxBodySize
//        let maxUploadSize = formatter.string(fromByteCount: Int64(byteCount.value))
//        templateData["maxUploadSize"] = .string(maxUploadSize)
//
//        return req.tau.render(template: "File/Admin/Upload", context: .init(templateData))
//    }
//    
//    func uploadView(req: Request) -> EventLoopFuture<View> {
//        renderUploadView(req: req, form: .init())
//    }
//    
//    func upload(req: Request) throws -> EventLoopFuture<Response> {
//        try req.validateFormToken(for: "file-upload-form")
//        
//        let form = FileUploadForm()
//        return form.initialize(req: req)
//            .flatMap { form.process(req: req) }
//            .flatMap { form.validate(req: req) }
//            .flatMap { [self] isValid in
//                guard isValid else {
//                    return renderUploadView(req: req, form: form).encodeResponse(for: req)
//                }
//                
//                let futures = form.files.values.map { file -> EventLoopFuture<String> in
//                    /// NOTE: better key validation on long term...
//                    let fileKey = String((form.key.value! + "/" + file.filename).safePath().dropFirst())
//                    return req.fs.upload(key: fileKey, data: file.dataValue!)
//                }
//                return req.eventLoop.flatten(futures).flatMap { _ in
//                    req.redirect(to: "/admin/file/browser/?key=\(form.key.value!)").encodeResponse(for: req)
//                }
//            }
//    }
//    
//    // MARK: - delete
//    
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
//    
}
