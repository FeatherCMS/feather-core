//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 03. 22..
//

//public final class Form: Codable {
//
//    public struct Action: Codable {
//        public enum Method: String, Codable {
//            case get
//            case post
//        }
//        public let method: Method
//        public let url: String?
//        public let multipart: Bool
//        
//        public init(method: Method = .post,
//                    url: String? = nil,
//                    multipart: Bool = false) {
//            self.method = method
//            self.url = url
//            self.multipart = multipart
//        }
//    }
//
//    public var id: String
//    public var key: String
//    public var token: String
//    public var label: String?
//    public var description: String?
//    public var `class`: String?
//    public var action: Action
//    public var notification: Notification?
//    public var error: String?
//    public var groups: [FormFieldGroup]
//    
//    public init(id: String,
//                key: String,
//                token: String,
//                label: String? = nil,
//                description: String? = nil,
//                class: String? = nil,
//                action: Action = Action(),
//                notification: Notification? = nil,
//                error: String? = nil,
//                groups: [FormFieldGroup]) {
//        self.id = id
//        self.key = key
//        self.token = token
//        self.label = label
//        self.description = description
//        self.class = `class`
//        self.action = action
//        self.notification = notification
//        self.error = error
//        self.groups = groups
//    }
//
//    public func field(_ id: String) -> FormField? {
//        for group in groups {
//            for field in group.fields {
//                if field.id == id {
//                    return field
//                }
//            }
//        }
//        return nil
//    }
//}
//
