//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

extension CommonVariable {
    
    public struct Patch: Codable {
        public var key: String?
        public var name: String?
        public var value: String?
        public var notes: String?
        
        public init(key: String? = nil,
                    name: String? = nil,
                    value: String? = nil,
                    notes: String? = nil)
        {
            self.key = key
            self.name = name
            self.value = value
            self.notes = notes
        }
    }
}
