//
//  RedirectRuleDetailObject.swift
//  
//
//  Created by Steve Tibbett on 2021-12-19
//

import Foundation
import FeatherCoreApi

extension RedirectRule {
    
    public struct Detail: Codable {
        public var id: UUID
        public var source: String
        public var destination: String
        public var statusCode: Int
        public var notes: String?
        
        public init(id: UUID,
                    source: String,
                    destination: String,
                    statusCode: Int,
                    notes: String? = nil)
        {
            self.id = id
            self.source = source
            self.destination = destination
            self.statusCode = statusCode
            self.notes = notes
        }
    }
}
