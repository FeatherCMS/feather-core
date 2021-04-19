//
//  FileFormField.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 12. 09..
//

/// represents a file data value
class ImageField: FormField<ImageInput, ImageFieldView> {

//    let path: String!
//    var imageKey: String?

    convenience init(key: String) {
        self.init(key: key, input: .init(key: key), output: .init(key: key))
    }
    
    override func process(req: Request) -> EventLoopFuture<Void> {
        input.process(req: req)
        return uploadTemporaryFile(req: req).map { [unowned self] in
            output.originalKey = input.currentKey
            output.temporaryKey = input.temporaryImage?.key
            output.temporaryName = input.temporaryImage?.name
            output.delete = input.remove
        }
    }

    // MARK: - helpers
    
    private func removeTemporaryFile(req: Request) -> EventLoopFuture<Void> {
        if let file = input.temporaryImage {
            return req.fs.delete(key: file.key).map { [unowned self] in
                input.temporaryImage = nil
            }
        }
        return req.eventLoop.future()
    }

    private func updateCurrentKey(_ key: String?, req: Request) -> EventLoopFuture<String?> {
        var future = req.eventLoop.future()
        if let key = input.currentKey {
            future = future.flatMap { req.fs.delete(key: key) }
        }
        return future.map { [unowned self] in
            input.currentKey = key
            return key
        }
    }
    
    private func uploadTemporaryFile(req: Request) -> EventLoopFuture<Void> {
        /// we only manipulate temporary files here...
        var future = req.eventLoop.future()
        if input.remove {
            future = removeTemporaryFile(req: req)
        }
        else if let file = input.file, let data = file.dataValue, !data.isEmpty {
            let key = "tmp/\(UUID().uuidString).tmp"
            /// remove previous temp file and upload new one
            future = removeTemporaryFile(req: req).flatMap {
                req.fs.upload(key: key, data: data).map { [unowned self] url in
                    input.temporaryImage = .init(key: key, name: file.filename)
                }
            }
        }
        return future
    }

    // MARK: - api
    

    public func saveImage(to path: String, req: Request) -> EventLoopFuture<String?> {
        var future: EventLoopFuture<String?> = req.eventLoop.future(nil)
        /// if there is a delete flag we simply remove the original file
        if input.remove {
            future = updateCurrentKey(nil, req: req)
        }
        else if let file = input.temporaryImage {
            let destination = path + file.name

            /// if the target file already exists we give it a timestamp as a prefix
            future = req.fs.exists(key: destination)
                .map { exists -> String in
                    if exists {
                        let formatter = DateFormatter()
                        formatter.dateFormat="y-MM-dd-HH-mm-ss-"
                        let prefix = formatter.string(from: .init())
                        return path + prefix + file.name
                    }
                    return destination
                }
                .flatMap { dest in
                    req.fs.move(key: file.key, to: dest).flatMap { [unowned self] _ in
                        input.temporaryImage = nil
                        return updateCurrentKey(dest, req: req)
                    }
                }
        }
        return future
    }
}



