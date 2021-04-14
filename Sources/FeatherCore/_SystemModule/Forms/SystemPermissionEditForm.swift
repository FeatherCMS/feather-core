//
//  UserPermissionEditForm.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

//final class SystemPermissionEditForm: EditForm {
//    typealias Model = SystemPermissionModel
//
//    var modelId: UUID?
//    var module = FormField<String>(key: "module").required().length(max: 250)
//    var context = FormField<String>(key: "context").required().length(max: 250)
//    var action = FormField<String>(key: "action").required().length(max: 250)
//    var name = FormField<String>(key: "name").required().length(max: 250)
//    var notes = FormField<String>(key: "notes").length(max: 250)
//    var notification: String?
//
//    var fields: [FormFieldRepresentable] {
//        [module, context, action, name, notes]
//    }
//
//    init() {}
//    
//    func validateAfterFields(req: Request) -> EventLoopFuture<Bool> {
//        SystemPermissionModel.query(on: req.db)
//            .filter(\.$namespace == module.value!)
//            .filter(\.$context == context.value!)
//            .filter(\.$action == action.value!)
//            .first()
//            .map { [unowned self] model -> Bool in
//                if (modelId == nil && model != nil) || (modelId != nil && model != nil && modelId! != model!.id) {
//                    module.error = "This combination is already in use"
//                    context.error = module.error
//                    action.error = module.error
//                    return false
//                }
//                return true
//            }
//    }
//
//    func read(from input: Model)  {
//        module.value = input.namespace
//        context.value = input.context
//        action.value = input.action
//        name.value = input.name
//        notes.value = input.notes
//    }
//
//    func write(to output: Model) {
//        output.namespace = module.value!
//        output.context = context.value!
//        output.action = action.value!
//        output.name = name.value!
//        output.notes = notes.value?.emptyToNil
//    }
//}
