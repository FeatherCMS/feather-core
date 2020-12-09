//
//  FrontendPageEditForm.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

final class FrontendPageEditForm: ModelForm {

    typealias Model = FrontendPageModel

    var modelId: UUID? = nil
    var title = FormField<String>(key: "title").required().length(max: 250)
    var content = FormField<String>(key: "content").required()
    var notification: String?
    var metadata: FrontendMetadata?

    var fields: [FormFieldRepresentable] {
        [title, content]
    }

    var leafData: LeafData {
        .dictionary([
            "modelId": modelId?.encodeToLeafData() ?? .string(nil),
            "fields": fieldsLeafData,
            "notification": .string(notification),
            "metadata": metadata?.leafData ?? .dictionary(nil)
        ])
    }

    init() {}
    
    func initialize(req: Request) -> EventLoopFuture<Void> {
        if let id = modelId {
            return Model.findMetadata(id: id, on: req.db).map { [unowned self] in metadata = $0 }
        }
        return req.eventLoop.future()
    }

    func read(from input: Model)  {
        title.value = input.title
        content.value = input.content
    }
    
    func write(to output: Model) {
        output.title = title.value!
        output.content = content.value!
    }
}
