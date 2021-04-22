//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 22..
//

extension PermissionCreateObject {

    init(_ permission: Permission) {
        self.init(namespace: permission.namespace,
                  context: permission.context,
                  action: permission.action.identifier,
                  name: permission.name)
    }
}
