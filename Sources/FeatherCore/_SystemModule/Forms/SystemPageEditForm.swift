////
////  FrontendPageEditForm.swift
////  FrontendModule
////
////  Created by Tibor Bodecs on 2020. 06. 09..
////
//
final class SystemPageEditForm: EditForm {

    typealias Model = SystemPageModel

    var modelId: UUID? = nil
    var title = TextField(key: "title", required: true)
    var content = TextField(key: "content", required: true)
    var notification: String?
    var metadata: Metadata?

    var fields: [FormFieldRepresentable] {
        [title, content]
    }

    var templateData: TemplateData {
        .dictionary([
            "modelId": modelId?.encodeToTemplateData() ?? .string(nil),
            "fields": fieldsTemplateData,
            "notification": .string(notification),
            "metadata": metadata?.encodeToTemplateData() ?? .dictionary(nil)
        ])
    }

    init() {}
    
    func initialize(req: Request) -> EventLoopFuture<Void> {
        if let id = modelId {
            return Model.findMetadata(reference: id, on: req.db) .map { [unowned self] in metadata = $0 }
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
