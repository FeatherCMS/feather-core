//
//  FileFormField+Upload.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 09..
//

public extension FileFormField {

    private func removeTemporaryFile(req: Request) -> EventLoopFuture<Void> {
        if let file = value.temporaryFile {
            return req.fs.delete(key: file.key).map { [unowned self] in
                value.temporaryFile = nil
            }
        }
        return req.eventLoop.future()
    }

    private func updateOriginalKey(_ key: String?, req: Request) -> EventLoopFuture<String?> {
        var future = req.eventLoop.future()
        if let key = value.originalKey {
            future = future.flatMap { req.fs.delete(key: key) }
        }
        return future.map { [unowned self] in
            value.originalKey = key
            return key
        }
    }

    func uploadTemporaryFile(req: Request) -> EventLoopFuture<Void> {
        /// we only manipulate temporary files here...
        var future = req.eventLoop.future()
        if value.delete {
            future = removeTemporaryFile(req: req)
        }
        else if let file = value.file, let data = file.dataValue, !data.isEmpty {
            let key = "tmp/\(UUID().uuidString).tmp"
            /// remove previous temp file and upload new one
            future = removeTemporaryFile(req: req).flatMap {
                req.fs.upload(key: key, data: data).map { [unowned self] url in
                    value.temporaryFile = .init(key: key, name: file.filename)
                }
            }
        }
        return future
    }

    func save(to path: String, req: Request) -> EventLoopFuture<String?> {
        var future: EventLoopFuture<String?> = req.eventLoop.future(nil)
        /// if there is a delete flag we simply remove the original file
        if value.delete {
            future = updateOriginalKey(nil, req: req)
        }
        else if let file = value.temporaryFile {
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
                        value.temporaryFile = nil
                        return updateOriginalKey(dest, req: req)
                    }
                }
        }
        return future
    }
}
