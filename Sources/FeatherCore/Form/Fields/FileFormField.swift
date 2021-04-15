//
//  FileFormField.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 12. 09..
//

/// represents a file data value
public final class FileValue: Encodable {

    public struct TemporaryFile: Encodable {
        public let key: String
        public let name: String
        
        public init(key: String, name: String) {
            self.key = key
            self.name = name
        }   
    }

    public var file: File?
    public var originalKey: String?
    public var delete: Bool
    public var temporaryFile: TemporaryFile?

    public init(file: File? = nil, originalKey: String? = nil, delete: Bool = false, temporaryFile: TemporaryFile? = nil) {
        self.file = file
        self.originalKey = originalKey
        self.delete = delete
        self.temporaryFile = temporaryFile
    }
}

//public final class FileFormField: FormFieldRepresentable {
//
//    public var key: String
//    public var value: FileValue
//    public var name: String?
//    public var validators: [(FileFormField) -> Bool]
//    public var error: String?
//
//    public init(key: String,
//                value: FileValue = .init(),
//                name: String? = nil,
//                validators: [(FileFormField) -> Bool] = [],
//                error: String? = nil)
//    {
//        self.key = key
//        self.value = value
//        self.name = name
//        self.validators = validators
//        self.error = error
//    }
//
//    /// template data representation of the form field
//    public var templateData: TemplateData {
//        .dictionary([
//            "key": key,
//            "name": name,
//            "value": value,
//            "error": error,
//        ])
//    }
//
//    /// validates a form field
//    public func validate() -> Bool {
//        /// clean previous error messages
//        error = nil
//        /// run validators again...
//        var isValid = true
//        for validator in validators {
//            /// stop if a field was already invalid
//            isValid = isValid && validator(self)
//        }
//        return isValid
//    }
//    
//    public func process(req: Request) {
//        
//        let originalKey = key+"OriginalKey"
//        let tempKey = key+"TemporaryKey"
//        let tempNameKey = key+"TemporaryName"
//        let deleteKey = key+"Delete"
//
//        value.file = try? req.content.get(File.self, at: key)
//        value.originalKey = try? req.content.get(String.self, at: originalKey)
//        if
//            let key = try? req.content.get(String.self, at: tempKey),
//            let name = try? req.content.get(String.self, at: tempNameKey)
//        {
//            value.temporaryFile = .init(key: key, name: name)
//        }
//        value.delete = (try? req.content.get(Bool.self, at: deleteKey)) ?? false
//    }
//}
//
//public extension FileFormField {
//    
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
//}

//public extension FileFormField {
//
//    private func removeTemporaryFile(req: Request) -> EventLoopFuture<Void> {
//        if let file = value.temporaryFile {
//            return req.fs.delete(key: file.key).map { [unowned self] in
//                value.temporaryFile = nil
//            }
//        }
//        return req.eventLoop.future()
//    }
//
//    private func updateOriginalKey(_ key: String?, req: Request) -> EventLoopFuture<String?> {
//        var future = req.eventLoop.future()
//        if let key = value.originalKey {
//            future = future.flatMap { req.fs.delete(key: key) }
//        }
//        return future.map { [unowned self] in
//            value.originalKey = key
//            return key
//        }
//    }
//
//    func uploadTemporaryFile(req: Request) -> EventLoopFuture<Void> {
//        /// we only manipulate temporary files here...
//        var future = req.eventLoop.future()
//        if value.delete {
//            future = removeTemporaryFile(req: req)
//        }
//        else if let file = value.file, let data = file.dataValue, !data.isEmpty {
//            let key = "tmp/\(UUID().uuidString).tmp"
//            /// remove previous temp file and upload new one
//            future = removeTemporaryFile(req: req).flatMap {
//                req.fs.upload(key: key, data: data).map { [unowned self] url in
//                    value.temporaryFile = .init(key: key, name: file.filename)
//                }
//            }
//        }
//        return future
//    }
//
//    func save(to path: String, req: Request) -> EventLoopFuture<String?> {
//        var future: EventLoopFuture<String?> = req.eventLoop.future(nil)
//        /// if there is a delete flag we simply remove the original file
//        if value.delete {
//            future = updateOriginalKey(nil, req: req)
//        }
//        else if let file = value.temporaryFile {
//            let destination = path + file.name
//
//            /// if the target file already exists we give it a timestamp as a prefix
//            future = req.fs.exists(key: destination)
//                .map { exists -> String in
//                    if exists {
//                        let formatter = DateFormatter()
//                        formatter.dateFormat="y-MM-dd-HH-mm-ss-"
//                        let prefix = formatter.string(from: .init())
//                        return path + prefix + file.name
//                    }
//                    return destination
//                }
//                .flatMap { dest in
//                    req.fs.move(key: file.key, to: dest).flatMap { [unowned self] _ in
//                        value.temporaryFile = nil
//                        return updateOriginalKey(dest, req: req)
//                    }
//                }
//        }
//        return future
//    }
//}
