//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

public extension System {
    
    enum Variable: FeatherApiModel {
        public typealias Module = System
    }
}

public extension System.Variable {
    
    // MARK: -
    
    struct List: Codable {
        public var id: UUID
        public var key: String
        public var value: String?
        
        public init(id: UUID,
                    key: String,
                    value: String? = nil) {
            self.id = id
            self.key = key
            self.value = value
        }
    }
    
    // MARK: -
    
    struct Detail: Codable {
        public var id: UUID
        public var key: String
        public var name: String
        public var value: String?
        public var notes: String?
        
        public init(id: UUID,
                    key: String,
                    name: String,
                    value: String? = nil,
                    notes: String? = nil) {
            self.id = id
            self.key = key
            self.name = name
            self.value = value
            self.notes = notes
        }
    }
    
    // MARK: -
    
    struct Create: Codable {
        public var key: String
        public var name: String
        public var value: String?
        public var notes: String?
        
        public init(key: String,
                    name: String,
                    value: String? = nil,
                    notes: String? = nil) {
            self.key = key
            self.name = name
            self.value = value
            self.notes = notes
        }
    }
    
    // MARK: -
    
    struct Update: Codable {
        public var key: String
        public var name: String
        public var value: String?
        public var notes: String?
        
        public init(key: String,
                    name: String,
                    value: String? = nil,
                    notes: String? = nil) {
            self.key = key
            self.name = name
            self.value = value
            self.notes = notes
        }
    }
    
    // MARK: -
    
    struct Patch: Codable {
        public var key: String?
        public var name: String?
        public var value: String?
        public var notes: String?
        
        public init(key: String? = nil,
                    name: String? = nil,
                    value: String? = nil,
                    notes: String? = nil) {
            self.key = key
            self.name = name
            self.value = value
            self.notes = notes
        }
    }
}

