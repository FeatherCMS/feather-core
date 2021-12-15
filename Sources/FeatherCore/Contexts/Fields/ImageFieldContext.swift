//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Foundation
import SwiftHtml

public struct ImageFieldContext {
    
    public struct TemporaryFile {
        public let key: String
        public let name: String
        
        public init(key: String, name: String) {
            self.key = key
            self.name = name
        }
    }
    
    public let key: String
    public var label: LabelContext
    public var placeholderIcon: String?
    public var originalKey: String?
    public var temporaryFile: TemporaryFile?
    public var remove: Bool
    public var previewUrl: String?
    public var accept: String?
    public var error: String?
    
    public init(key: String,
                label: LabelContext? = nil,
                placeholderIcon: String? = nil,
                originalKey: String? = nil,
                temporaryFile: TemporaryFile? = nil,
                remove: Bool = false,
                previewUrl: String? = nil,
                accept: String? = nil,
                error: String? = nil) {
        self.key = key
        self.label = label ?? .init(key: key)
        self.placeholderIcon = placeholderIcon
        self.originalKey = originalKey
        self.temporaryFile = temporaryFile
        self.remove = remove
        self.previewUrl = previewUrl
        self.accept = accept
        self.error = error
    }
}
