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
        let permission = params[0].string!
        let hasPermission: Bool? = req.invoke("template-permission-hook", args: ["key": permission])
        return .bool(hasPermission ?? false)
    }
}
