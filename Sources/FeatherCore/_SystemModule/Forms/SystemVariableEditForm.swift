//
//  SystemVariableEditForm.swift
//  SystemModule
//
//  Created by Tibor Bodecs on 2020. 06. 10..
//
//


final class SystemVariableEditForm: ModelForm<SystemVariableModel> {

    convenience required init() {
        self.init(fields: [])

        self.fields = [
            TextField(key: "name")
                .onInitialize { req, field in
                    field.output.value = "test"
                    return req.eventLoop.future()
                }
                .onLoad { [unowned self] req, field in
                    field.output.value = model?.name ?? ""
                    return req.eventLoop.future()
                }
                .onSave { [unowned self] req, field in
                    model?.name = field.input
                    return req.eventLoop.future()
                }
            ,
            TextField(key: "key")
                .onInitialize { req, field in
                    field.output.value = "test"
                    return req.eventLoop.future()
                }
                .onLoad { [unowned self] req, field in
                    field.output.value = model?.key ?? ""
                    return req.eventLoop.future()
                }
                .onSave { [unowned self] req, field in
                    model?.key = field.input
                    return req.eventLoop.future()
                }
            ,
            TextareaField(key: "value")
                .onInitialize { req, field in
                    field.output.value = "test"
                    return req.eventLoop.future()
                }
                .onLoad { [unowned self] req, field in
                    field.output.value = model?.value ?? ""
                    return req.eventLoop.future()
                }
                .onSave { [unowned self] req, field in
                    model?.value = field.input
                    return req.eventLoop.future()
                }
            ,
            TextareaField(key: "notes")
                .onInitialize { req, field in
                    field.output.value = "test"
                    return req.eventLoop.future()
                }
                .onLoad { [unowned self] req, field in
                    field.output.value = model?.notes ?? ""
                    return req.eventLoop.future()
                }
                .onSave { [unowned self] req, field in
                    model?.notes = field.input
                    return req.eventLoop.future()
                }
            ,
        ]
    }

//    func uniqueKeyValidator(optional: Bool = false) -> ContentValidator<String> {
//        return ContentValidator<String>(key: "key", message: "Key must be unique", asyncValidation: { value, req in
//            var query = SystemVariableModel.query(on: req.db).filter(\.$key == value)
//            if let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) {
//                query = query.filter(\.$id != uuid)
//            }
//            return query.count().map { $0 == 0  }
//        })
//    }
//    
//    var model: String? = nil
//
//    init() {
//        key.validation.validators.append(uniqueKeyValidator())
//        
//        CTRL().teest()
//    }
//
//    func initialize(req: Request) -> EventLoopFuture<Void> {
//        
//
//        let fields: [FormFieldRepresentable] = [
////            TextField(key: "email")
////                .onInitialize(req) { req, field in
////                    field.output.required = false
////                    field.output.key = field.key
////                    field.output.value = ""
////
////                    return req.eventLoop.future()
////                }
////                .onProcess(req) { req, field in
////                    field.input.value = try req.content.get(String.self, at: field.key)
////                }
////                .onValidate(req) { req, field in
////                    InputValidator([
////                        ContentValidator<String>.init(key: field.key, message: "Field is required"),
////                    ]).validate(req).map { $0.isEmpty }
////                }
////                .onLoad(req) { [unowned self] req, field in
////                    field.output.value = model
////                }
////                .onSave(req) { [unowned self] req, field in
////                    model = field.input.value
////                },
////            
////            TextField(key: "password")
////                .onInitialize(req) { req, field in
////                    field.output.required = false
////                    field.output.key = field.key
////                    field.output.value = ""
////
////                    return req.eventLoop.future()
////                }
////                .onProcess(req) { req, field in
////                    field.input.value = try req.content.get(String.self, at: field.key)
////                }
////                .onValidate(req) { req, field in
////                    InputValidator([
////                        ContentValidator<String>.init(key: field.key, message: "Field is required"),
////                    ]).validate(req).map { $0.isEmpty }
////                }
////                .onSave(req) { [unowned self] req, field in
////                    model = field.input.value
////                },
//
////            SubmitField("Save"),
//        ]
//        
//        return req.eventLoop.future()
//    }
//
//    func read(from input: Model)  {
//        key.output.value = input.key
//        name.output.value = input.name
//        value.output.value = input.value
//        notes.output.value = input.notes
//    }
//
//    func write(to output: Model) {
//        output.key = key.input.value!
//        output.name = name.input.value!
//        output.value = value.input.value?.emptyToNil
//        output.notes = notes.input.value?.emptyToNil
//    }
}

