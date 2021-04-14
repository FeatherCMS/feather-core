//
//  MenuEditForm.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

//final class SystemMenuItemEditForm: EditForm {
//    typealias Model = SystemMenuItemModel
//
//    var modelId: UUID?
//    var icon = FormField<String>(key: "icon")
//    var label = FormField<String>(key: "label").required().length(max: 250)
//    var url = FormField<String>(key: "url").required().length(max: 250)
//    var priority = FormField<Int>(key: "priority")
//    var targetBlank = FormField<Bool>(key: "targetBlank")
//    var permission = FormField<String>(key: "permission").length(max: 250)
//    var menuId = FormField<UUID>(key: "menuId")
//    var notification: String?
//    
//    var fields: [FormFieldRepresentable] {
//        [icon, label, url, priority, targetBlank, permission, menuId]
//    }
//
//    init() {}
//
//    func initialize(req: Request) -> EventLoopFuture<Void> {
//        targetBlank.value = false
//        priority.value = 100
//        return req.eventLoop.future()
//    }
//
//    func read(from input: Model)  {
//        icon.value = input.icon
//        label.value = input.label
//        url.value = input.url
//        priority.value = input.priority
//        targetBlank.value = input.isBlank
//        permission.value = input.permission
//        menuId.value = input.$menu.id
//    }
//
//    func write(to output: Model) {
//        output.icon = icon.value?.emptyToNil
//        output.label = label.value!
//        output.url = url.value!
//        output.priority = priority.value!
//        output.isBlank = targetBlank.value!
//        output.permission = permission.value?.emptyToNil
//        output.$menu.id = menuId.value!
//    }
//}
