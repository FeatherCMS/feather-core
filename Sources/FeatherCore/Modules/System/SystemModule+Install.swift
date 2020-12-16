//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 14..
//

extension SystemModule {

    func modelInstallHook(args: HookArguments) -> EventLoopFuture<Void> {
        let req = args["req"] as! Request

        let variableItems: [[[String: Any]]] = req.invokeAll("system-variables-install")
        let systemVariableModels = variableItems.flatMap { $0 }.compactMap { dict -> SystemVariableModel? in
            guard
                let key = dict["key"] as? String, !key.isEmpty,
                let name = dict["name"] as? String, !name.isEmpty
            else {
                return nil
            }
            let value = dict["value"] as? String
            let hidden = dict["hidden"] as? Bool ?? false
            let notes = dict["notes"] as? String
            return SystemVariableModel(key: key, name: name, value: value, hidden: hidden, notes: notes)
        }
        return systemVariableModels.create(on: req.db)
    }

    func userPermissionInstallHook(args: HookArguments) -> [[String: Any]] {
        SystemModule.permissions + 
        SystemVariableModel.permissions
    }
}
