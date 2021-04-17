////
////  FrontendPageEditForm.swift
////  FrontendModule
////
////  Created by Tibor Bodecs on 2020. 06. 09..
////
//
final class SystemPageEditForm: EditForm {

    typealias Model = SystemPageModel

    var title = TextField(key: "title", required: true)
    var content = TextareaField(key: "content", required: true)
    var notification: String?
    var metadata: Metadata?

    var fields: [FormFieldRepresentable] {
        [title, content]
    }

    var templateData: TemplateData {
        .dictionary([
            "fields": fieldsTemplateData,
            "notification": .string(notification),
            "metadata": metadata?.encodeToTemplateData() ?? .dictionary(nil)
        ])
    }

    init() {}
    
    func initialize(req: Request) -> EventLoopFuture<Void> {
        if let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) {
            return Model.findMetadata(reference: uuid, on: req.db) .map { [unowned self] in metadata = $0 }
        }
        return req.eventLoop.future()
    }

    func read(from input: Model)  {
        title.output.value = input.title
        content.output.value = input.content
    }
    
    func write(to output: Model) {
        output.title = title.input.value!
        output.content = content.input.value!
    }
}






