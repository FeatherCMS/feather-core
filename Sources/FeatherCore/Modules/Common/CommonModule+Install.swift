//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//

extension CommonModule {
        
    func installModelsHook(args: HookArguments) -> EventLoopFuture<Void> {
        let req = args.req

        let variableItems: [[CommonVariable]] = req.invokeAll(.installVariables)
        let variableModels = variableItems.flatMap { $0 }.map {
            CommonVariableModel(key: $0.key, name: $0.name, value: $0.value, notes: $0.notes)
        }
        return variableModels.create(on: req.db)
    }
    
    func installPermissionsHook(args: HookArguments) -> [UserPermission] {
        var permissions: [UserPermission] = [
            CommonModule.systemPermission(for: .custom("admin"))
        ]
        
        permissions += CommonVariableModel.systemPermissions()
//        FileModule.permissions +
//        [
//            [
//                "module": Self.name.lowercased(),
//                "context": "browser",
//                "action": "list",
//                "name": "List items",
//            ],
//            [
//                "module": Self.name.lowercased(),
//                "context": "browser",
//                "action": "create",
//                "name": "Upload items",
//            ],
//            [
//                "module": Self.name.lowercased(),
//                "context": "browser",
//                "action": "delete",
//                "name": "Remove items",
//            ]
//        ]
        return permissions
    }
    
    func installVariablesHook(args: HookArguments) -> [CommonVariable] {
        [
            // MARK: - not found

            .init(key: "notFoundPageIcon",
                  value:  "🙉",
                  name: "Page not found icon",
                  notes: "Icon for the not found page"),
            
            .init(key: "notFoundPageTitle",
                  value: "Page not found",
                  name: "Page not found title",
                  notes: "Title of the not found page"),
            
            .init(key: "notFoundPageExcerpt",
                  value: "Unfortunately the requested page is not available.",
                  name: "Page not found excerpt",
                  notes: "Excerpt for the not found page"),

            .init(key: "notFoundPageLinkLabel",
                  value: "Go to the home page →",
                  name: "Page not found link label",
                  notes: "Retry link text for the not found page"),

            .init(key: "notFoundPageLinkUrl",
                  value: "/",
                  name: "Page not found link URL",
                  notes: "Retry link URL for the not found page"),

            // MARK: - empty list
 
            .init(key: "emptyListIcon",
                  value: "🔍",
                  name: "Empty list icon",
                  notes: "Icon for the empty list results view."),
            
            .init(key: "emptyListTitle",
                  value: "Empty list",
                  name: "Empty list title",
                  notes: "Title for the empty list results view."),
            
            .init(key: "emptyListDescription",
                  value: "Unfortunately there are no results.",
                  name: "Empty list description",
                  notes: "Description of the empty list box"),
            
            .init(key: "emptyListLinkLabel",
                  value: "Try again from scratch →",
                  name: "Empty list link label",
                  notes: "Start over link text for the empty list box"),
        ]
    }
}
