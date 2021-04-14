//
//  MenuEditForm.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

final class SystemMenuItemEditForm: EditForm {
    typealias Model = SystemMenuItemModel

    var modelId: UUID?
    var icon = TextField(key: "icon")
    var label = TextField(key: "label", required: true)
    var url = TextField(key: "url", required: true)
    var priority = TextField(key: "priority", required: true)
    var targetBlank = ToggleField(key: "targetBlank")
    var permission = TextField(key: "permission")
    var menuId = TextField(key: "menuId")
    var notification: String?
    
    var fields: [FormFieldRepresentable] {
        [icon, label, url, priority, targetBlank, permission, menuId]
    }

    init() {}

    func initialize(req: Request) -> EventLoopFuture<Void> {
        targetBlank.output.value = false
        priority.output.value = "100"
        return req.eventLoop.future()
    }

    func read(from input: Model)  {
        icon.output.value = input.icon
        label.output.value = input.label
        url.output.value = input.url
        priority.output.value = String(input.priority)
        targetBlank.output.value = input.isBlank
        permission.output.value = input.permission
        menuId.output.value = input.$menu.id.uuidString
    }

    func write(to output: Model) {
        #warning("validation / input types")
        output.icon = icon.input.value?.emptyToNil
        output.label = label.input.value!
        output.url = url.input.value!
        output.priority = Int(priority.input.value!)!
        output.isBlank = targetBlank.input.value!
        output.permission = permission.input.value?.emptyToNil
        output.$menu.id = UUID(uuidString: menuId.input.value!)!
    }
}
