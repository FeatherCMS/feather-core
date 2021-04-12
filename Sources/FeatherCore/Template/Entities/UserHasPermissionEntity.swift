//
//  UserHasPermissionEntity.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

/// check if the current user has permission to a given action (User meaning is not UserModule, but the end-user instead)
public struct UserHasPermissionEntity: UnsafeEntity, NonMutatingMethod, BoolReturn {

    public var unsafeObjects: UnsafeObjects? = nil
    
    public static var callSignature: [CallParameter] { [.string] }
    
    public init() {}

    public func evaluate(_ params: CallValues) -> TemplateData {
        guard let req = req else { return .error("Needs unsafe access to Request") }
        let rawPermission = params[0].string!
        let components = rawPermission.components(separatedBy: ".")
        guard components.count == 3 else { return .error("Invalid permission components: `\(rawPermission)`.") }
        
        let permission =  Permission(namespace: components[0], context: components[1], action: .init(identifier: components[2]))
        let hasPermission: Bool? = req.invoke("permission", args: ["permission": permission])
        return .bool(hasPermission ?? false)
    }
}
