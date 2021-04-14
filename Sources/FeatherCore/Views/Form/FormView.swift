//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

import Foundation

public struct FormView: Encodable {
    
    public struct Action: Encodable {
        public enum Method: String, Encodable {
            case get
            case post
        }
        public let method: Method
        public let url: String?
        public let multipart: Bool
        
        public init(method: Method = .post,
                    url: String? = nil,
                    multipart: Bool = false) {
            self.method = method
            self.url = url
            self.multipart = multipart
        }
    }

    public let id: String
    public let token: String
    public let title: String
    public let key: String
    public let modelId: String
    public let list: Link
    public let nav: [Link]
    public let notification: String?
}

