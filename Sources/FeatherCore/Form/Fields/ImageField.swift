//
//  FileFormField.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 12. 09..
//

/// represents a file data value
class ImageField: FormField {

    let key: String

    var input: GenericInput<ImageInput>
    var validation: InputValidator
    var output: ImageFieldView
    
    init(key: String, required: Bool = false) {
        self.key = key
        input = .init(key: key)
        validation = InputValidator()
        if required {
//            validation.validators.append(ContentValidator<String>.required(key: key))
            //    func required(message: String? = nil) -> Self {
            //        validators.append({ [unowned self] field -> Bool in
            //            if
            //                (field.value.temporaryFile == nil && field.value.delete) ||
            //                (field.value.temporaryFile == nil && field.value.originalKey == nil)
            //            {
            //                let message = message ?? "\(name ?? key.capitalized) is required"
            //                field.error = message
            //                return false
            //            }
            //            return true
            //        })
            //        return self
            //    }

        }
        output = .init(key: key, required: required)
    }

    // MARK: - helpers
    
    private func removeTemporaryFile(req: Request) -> EventLoopFuture<Void> {
        if let file = input.value?.temporaryImage {
            return req.fs.delete(key: file.key).map { [unowned self] in
                input.value?.temporaryImage = nil
            }
        }
        return req.eventLoop.future()
    }

    private func updateCurrentKey(_ key: String?, req: Request) -> EventLoopFuture<String?> {
        var future = req.eventLoop.future()
        if let key = input.value?.currentKey {
            future = future.flatMap { req.fs.delete(key: key) }
        }
        return future.map { [unowned self] in
            input.value?.currentKey = key
            return key
        }
    }

    // MARK: - api
    
    func uploadTemporaryFile(req: Request) -> EventLoopFuture<Void> {
        /// we only manipulate temporary files here...
        var future = req.eventLoop.future()
        if input.value?.remove ?? false {
            future = removeTemporaryFile(req: req)
        }
        else if let file = input.value?.file, let data = file.dataValue, !data.isEmpty {
            let key = "tmp/\(UUID().uuidString).tmp"
            /// remove previous temp file and upload new one
            future = removeTemporaryFile(req: req).flatMap {
                req.fs.upload(key: key, data: data).map { [unowned self] url in
                    input.value?.temporaryImage = .init(key: key, name: file.filename)
                }
            }
        }
        return future
    }

    func save(to path: String, req: Request) -> EventLoopFuture<String?> {
        var future: EventLoopFuture<String?> = req.eventLoop.future(nil)
        /// if there is a delete flag we simply remove the original file
        if input.value?.remove ?? false {
            future = updateCurrentKey(nil, req: req)
        }
        else if let file = input.value?.temporaryImage {
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
                        input.value?.temporaryImage = nil
                        return updateCurrentKey(dest, req: req)
                    }
                }
        }
        return future
    }
}



