//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 17..
//

public struct ImageFieldView: FormFieldView {

    public let type: FormFieldType = .image

    public var key: String
    public var required: Bool
    public var error: String?

    public var label: String?
    public var more: String?

    public var accept: String?
    public var originalKey: String?
    public var temporaryKey: String?
    public var temporaryName: String?
    public var delete: Bool

    public init(key: String,
                required: Bool = false,
                error: String? = nil,
                label: String? = nil,
                more: String? = nil,
                accept: String? = nil,
                originalKey: String? = nil,
                temporaryKey: String? = nil,
                temporaryName: String? = nil,
                delete: Bool = false) {
        self.key = key
        self.required = required
        self.error = error
        self.label = label
        self.more = more
        self.accept = accept
        self.originalKey = originalKey
        self.temporaryKey = temporaryKey
        self.temporaryName = temporaryName
        self.delete = delete
    }
}


