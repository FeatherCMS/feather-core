//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

public struct FileFieldContext {

    public let key: String
    public var label: LabelContext
    public var placeholderIcon: String?
    public var data: FormImageData
    public var previewKey: String?
    public var accept: String?
    public var error: String?
    
    public init(key: String,
                label: LabelContext? = nil,
                placeholderIcon: String? = nil,
                data: FormImageData = .init(),
                previewKey: String? = nil,
                accept: String? = nil,
                error: String? = nil) {
        self.key = key
        self.label = label ?? .init(key: key)
        self.placeholderIcon = placeholderIcon
        self.data = data
        self.previewKey = previewKey
        self.accept = accept
        self.error = error
    }
}
