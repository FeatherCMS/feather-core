//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 17..
//

public final class ImageInput: Codable, FormFieldInput {

    public struct TemporaryImage: Codable {
        public let key: String
        public let name: String
        
        public init(key: String, name: String) {
            self.key = key
            self.name = name
        }
    }

    public var key: String
    public var file: File?
    public var currentKey: String?
    public var temporaryImage: TemporaryImage?
    public var remove: Bool

    public init(key: String, file: File? = nil, currentKey: String? = nil, temporaryImage: TemporaryImage? = nil, remove: Bool = false) {
        self.key = key
        self.file = file
        self.currentKey = currentKey
        self.temporaryImage = temporaryImage
        self.remove = remove
    }

    public func process(req: Request) {
        file = try? req.content.get(File.self, at: key)
        currentKey = try? req.content.get(String.self, at: key+"CurrentKey")
        if
            let key = try? req.content.get(String.self, at: key+"TemporaryKey"),
            let name = try? req.content.get(String.self, at: key+"TemporaryName")
        {
            temporaryImage = .init(key: key, name: name)
        }
        remove = (try? req.content.get(Bool.self, at: key+"Remove")) ?? false
    }
}
