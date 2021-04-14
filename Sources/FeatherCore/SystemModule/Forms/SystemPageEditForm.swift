////
////  FrontendPageEditForm.swift
////  FrontendModule
////
////  Created by Tibor Bodecs on 2020. 06. 09..
////
//
//final class SystemPageEditForm: ModelForm {
//
//    typealias Model = SystemPageModel
//
//    var modelId: UUID? = nil
//    var title = FormField<String>(key: "title").required().length(max: 250)
//    var content = FormField<String>(key: "content").required()
//    var notification: String?
//    var metadata: Metadata?
//
//    var fields: [FormFieldRepresentable] {
//        [title, content]
//    }
//
//    var templateData: TemplateData {
//        .dictionary([
//            "modelId": modelId?.encodeToTemplateData() ?? .string(nil),
//            "fields": fieldsTemplateData,
//            "notification": .string(notification),
//            "metadata": metadata?.templateData ?? .dictionary(nil)
//        ])
//    }
//
//    init() {}
//    
//    func initialize(req: Request) -> EventLoopFuture<Void> {
//        if let id = modelId {
//            return Model.findMetadata(reference: id, on: req.db) .map { [unowned self] in metadata = $0 }
//        }
//        return req.eventLoop.future()
//    }
//
//    func read(from input: Model)  {
//        title.value = input.title
//        content.value = input.content
//    }
//    
//    func write(to output: Model) {
//        output.title = title.value!
//        output.content = content.value!
//    }
//}
