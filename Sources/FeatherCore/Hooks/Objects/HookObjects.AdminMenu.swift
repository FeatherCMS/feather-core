//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 03..
//

public extension HookObjects {

    struct AdminMenu: Codable {
        public let key: String
        public let item: HookObjects.AdminMenuItem
        public let children: [HookObjects.AdminMenuItem]

        public init(key: String, item: HookObjects.AdminMenuItem, children: [HookObjects.AdminMenuItem] = []) {
            self.key = key
            self.item = item
            self.children = children
        }
    }
}

