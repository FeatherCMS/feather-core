//
//  FrontendPageEditForm.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

final class FrontendPageEditForm: ModelForm {

    typealias Model = FrontendPageModel

    struct Input: Decodable {
        var modelId: UUID?
        var title: String
        var content: String
    }

    var modelId: UUID? = nil
    var title = FormField<String>(key: "title").required().length(max: 250)
    var content = FormField<String>(key: "content").required()
    var notification: String?
    var metadata: FrontendMetadata?

    var fields: [AbstractFormField] {
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

    func processInput(req: Request) throws -> EventLoopFuture<Void> {
        let context = try req.content.decode(Input.self)
        modelId = context.modelId
        title.value = context.title
        content.value = context.content
        return req.eventLoop.future()
    }

    func read(from input: Model)  {
        modelId = input.id
        title.value = input.title
        content.value = input.content
    }
    
    func write(to output: Model) {
        output.title = title.value!
        output.content = content.value!
    }
}
