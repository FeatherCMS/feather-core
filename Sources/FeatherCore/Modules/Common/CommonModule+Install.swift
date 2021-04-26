//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//

extension CommonModule {
        
    func installModelsHook(args: HookArguments) -> EventLoopFuture<Void> {
        let req = args.req

        let variableItems: [[VariableCreateObject]] = req.invokeAll(.installVariables)
        let variableModels = variableItems.flatMap { $0 }.map {
            CommonVariableModel(key: $0.key, name: $0.name, value: $0.value, notes: $0.notes)
        }
        return variableModels.create(on: req.db)
    }
    
    func installPermissionsHook(args: HookArguments) -> [PermissionCreateObject] {
        var permissions: [PermissionCreateObject] = [
            CommonModule.hookInstallPermission(for: .custom("admin"))
        ]
        permissions += CommonVariableModel.hookInstallPermissions()
        permissions += [
            CommonModule.hookInstallPermission(for: .list, context: "files"),
            CommonModule.hookInstallPermission(for: .create, context: "files"),
            CommonModule.hookInstallPermission(for: .delete, context: "files"),
        ]
        return permissions
    }
    
    func installVariablesHook(args: HookArguments) -> [VariableCreateObject] {
        [
            // MARK: - not found

            .init(key: "pageNotFoundIcon",
                  name: "Page not found icon",
                  value:  "🙉",
                  notes: "Icon for the not found page"),
            
            .init(key: "pageNotFoundTitle",
                  name: "Page not found title",
                  value: "Page not found",
                  notes: "Title of the not found page"),
            
            .init(key: "pageNotFoundExcerpt",
                  name: "Page not found excerpt",
                  value: "Unfortunately the requested page is not available.",
                  notes: "Excerpt for the not found page"),

            .init(key: "pageNotFoundLinkLabel",
                  name: "Page not found link label",
                  value: "Go to the home page →",
                  notes: "Retry link text for the not found page"),

            .init(key: "pageNotFoundLinkUrl",
                  name: "Page not found link URL",
                  value: "/",
                  notes: "Retry link URL for the not found page"),

            // MARK: - empty list
 
            .init(key: "emptyListIcon",
                  name: "Empty list icon",
                  value: "🔍",
                  notes: "Icon for the empty list results view."),
            
            .init(key: "emptyListTitle",
                  name: "Empty list title",
                  value: "Empty list",
                  notes: "Title for the empty list results view."),
            
            .init(key: "emptyListDescription",
                  name: "Empty list description",
                  value: "Unfortunately there are no results.",
                  notes: "Description of the empty list box"),
            
            .init(key: "emptyListLinkLabel",
                  name: "Empty list link label",
                  value: "Try again from scratch →",
                  notes: "Start over link text for the empty list box"),
        ]
    }
}
