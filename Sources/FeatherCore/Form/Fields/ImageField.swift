//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import Liquid

public struct ImageInput: Decodable {
    
    public var key: String
    
    public var file: File?
    public var originalKey: String?
    public var temporaryKey: String?
    public var temporaryName: String?
    public var remove: Bool

    public init(key: String,
                file: File? = nil,
                originalKey: String? = nil,
                temporaryKey: String? = nil,
                temporaryName: String? = nil,
                remove: Bool = false) {
        self.key = key
        self.file = file
        self.originalKey = originalKey
        self.temporaryKey = temporaryKey
        self.temporaryName = temporaryName
        self.remove = remove
    }

    public mutating func process(req: Request) {
        file = try? req.content.get(File.self, at: key)
        originalKey = try? req.content.get(String.self, at: key + "OriginalKey")
        temporaryKey = try? req.content.get(String.self, at: key + "TemporaryKey")
        temporaryName = try? req.content.get(String.self, at: key + "TemporaryName")
        remove = (try? req.content.get(Bool.self, at: key + "Remove")) ?? false
    }
}


public final class ImageField: FormField<ImageInput, ImageFieldTemplate> {

    public convenience init(_ key: String) {
        self.init(key: key, input: .init(key: key), output: .init(.init(key: key)))
    }

    public override func process(req: Request) async {
        input.process(req: req)

        if input.remove {
            if let originalKey = input.originalKey {
                try? await req.fs.delete(key: originalKey)
            }
        }
        else if let file = input.file, let data = file.dataValue, !data.isEmpty {
            
            if let tmpKey = input.temporaryKey {
                try? await req.fs.delete(key: tmpKey)
            }
            let key = "tmp/\(UUID().uuidString).tmp"
            let newKey = try? await req.fs.upload(key: key, data: data)
            print(newKey)
        }
        // update output
    
        // process other actions, but do not call super here...
        await processBlock?(req, self)
    }
    

    public override func render(req: Request) -> TemplateRepresentable {
        output.context.error = error
        return super.render(req: req)
    }
}
