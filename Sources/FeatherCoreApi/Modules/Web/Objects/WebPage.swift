//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

public extension Web {
    
    enum Page: FeatherApiModel {
        public typealias Module = Web
    }
}

public extension Web.Page {
    
    // MARK: -
    
    struct List: Codable {
        public let id: UUID
        public let title: String
        public let metadata: FeatherMetadata
        
        public init(id: UUID,
                    title: String,
                    metadata: FeatherMetadata) {
            self.id = id
            self.title = title
            self.metadata = metadata
        }
    }
    
    // MARK: -
    
    struct Detail: Codable {
        public let id: UUID
        public let title: String
        public let content: String
        public let metadata: FeatherMetadata
        
        public init(id: UUID,
                    title: String,
                    content: String,
                    metadata: FeatherMetadata) {
            self.id = id
            self.title = title
            self.content = content
            self.metadata = metadata
        }
    }
    
    // MARK: -
    
    struct Create: Codable {
        public let title: String
        public let content: String

        public init(title: String,
                    content: String) {
            self.title = title
            self.content = content
        }
    }
    
    // MARK: -
    
    struct Update: Codable {
        public let title: String
        public let content: String
        
        public init(title: String,
                    content: String) {
            self.title = title
            self.content = content
        }
    }
    
    // MARK: -
    
    struct Patch: Codable {
        public let title: String?
        public let content: String?
        
        public init(title: String? = nil,
                    content: String? = nil) {
            self.title = title
            self.content = content
        }
    }
}
