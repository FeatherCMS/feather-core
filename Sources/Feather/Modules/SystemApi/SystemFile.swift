//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 03. 04..
//


public extension System {
    
    struct File: FeatherApiModel {
        public typealias Module = System
    }
}

public extension System.File {
    
    struct Item: Codable {
        public let path: String
        public let name: String
        public let ext: String?

        public init(path: String, name: String, ext: String? = nil) {
            self.path = path
            self.name = name
            self.ext = ext
        }
        
        public var isDirectory: Bool { ext == nil }
        public var isFile: Bool { !isDirectory }
    }

    struct Directory: Codable {
    
        public struct Create: Codable {
            public let key: String?
            public let name: String
            
            public init(key: String?, name: String) {
                self.key = key
                self.name = name
            }
        }
        
        struct List: Codable {
            public let current: Item?
            public let parent: Item?
            public let children: [Item]
            
            public init(current: Item?, parent: Item?, children: [Item]) {
                self.current = current
                self.parent = parent
                self.children = children
            }
        }
    }
   
}
