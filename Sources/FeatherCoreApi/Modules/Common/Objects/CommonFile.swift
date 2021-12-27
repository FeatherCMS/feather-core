//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

public enum CommonFile {}

public extension CommonFile {
    
    struct Directory: Codable {
    
        public struct Create: Codable {
            public let key: String?
            public let name: String
            
            public init(key: String?, name: String) {
                self.key = key
                self.name = name
            }
        }
    }
    
    struct List: Codable {
        
        public struct Item: Codable {
            public let key: String
            public let name: String
            public let ext: String?

            public var isDirectory: Bool { ext == nil }
            public var isFile: Bool { !isDirectory }
            
            public init(key: String, name: String, ext: String?) {
                self.key = key
                self.name = name
                self.ext = ext
            }
        }

        public let current: Item?
        public let parent: Item?
        public let children: [Item]
        
        public init(current: Item?, parent: Item?, children: [CommonFile.List.Item]) {
            self.current = current
            self.parent = parent
            self.children = children
        }
    }
}


