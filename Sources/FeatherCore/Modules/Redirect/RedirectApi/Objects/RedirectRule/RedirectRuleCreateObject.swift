//
//  RedirectRuleCreateObject.swift
//  
//
//  Created by Steve Tibbett on 2021-12-19
//

import Foundation

extension RedirectRule {

    public struct Create: Codable {
        public var source: String
        public var destination: String
        public var statusCode: Int
        public var notes: String?
        
        public init(source: String,
                    destination: String,
                    statusCode: Int,
                    notes: String? = nil)
        {
            self.source = source
            self.destination = destination
            self.statusCode = statusCode
            self.notes = notes
        }
    }

}
