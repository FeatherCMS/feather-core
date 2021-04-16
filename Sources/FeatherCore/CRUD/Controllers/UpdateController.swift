//
//  UpdateViewController.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol UpdateApiRepresentable: ModelApi {
    
    associatedtype UpdateObject: Codable
    
    func validateUpdate(_ req: Request) -> EventLoopFuture<Bool>
    func mapUpdate(model: Model, input: UpdateObject)
}

    
public protocol UpdateController: IdentifiableController {
    
    associatedtype UpdateApi: UpdateApiRepresentable & GetApiRepresentable
    associatedtype UpdateForm: EditForm

    /// the name of the update view template
    var updateView: String { get }

    /// this is called after form validation when the form is invalid
    func beforeInvalidUpdateFormRender(req: Request, form: UpdateForm) -> EventLoopFuture<UpdateForm>
    
    /// this is called before the form rendering happens (used both in createView and updateView)
    func beforeUpdateFormRender(req: Request, form: UpdateForm) -> EventLoopFuture<Void>

    /// renders the form using the given template
    func renderUpdateForm(req: Request, form: UpdateForm) -> EventLoopFuture<View>
    
    /// check if there is access to update the object, if the future the server will respond with a forbidden status
    func accessUpdate(req: Request) -> EventLoopFuture<Bool>
    
    /// renders the update form filled with the entity
    func updateView(req: Request) throws -> EventLoopFuture<View>
    
    /// this will be called before the model is updated
    func beforeUpdate(req: Request, model: Model, form: UpdateForm) -> EventLoopFuture<Model>
    
    /// update handler for the form submission
    func update(req: Request) throws -> EventLoopFuture<Response>
    
    /// runs after the model was updated
    func afterUpdate(req: Request, form: UpdateForm, model: Model) -> EventLoopFuture<Model>

    /// returns a response after the update flow
    func updateResponse(req: Request, form: UpdateForm, model: Model) -> EventLoopFuture<Response>
    
    func updateApi(_ req: Request) throws -> EventLoopFuture<UpdateApi.GetObject>
    
    /// setup update routes using the route builder
    func setupUpdateRoutes(on builder: RoutesBuilder, as: PathComponent)
    
    func setupUpdateApiRoute(on builder: RoutesBuilder)
}


public extension UpdateController {
    
    var updateView: String { "System/Admin/Form" }

    func beforeInvalidUpdateFormRender(req: Request, form: UpdateForm) -> EventLoopFuture<UpdateForm> {
        req.eventLoop.future(form)
    }

    func beforeUpdateFormRender(req: Request, form: UpdateForm) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }

    func createContext(req: Request, formId: String, formToken: String) -> FormView {
        .init(action: .init(),
              id: formId,
              token: formToken,
              title: "",
              notification: nil,
              nav: [],
              model: Model.info(req))
    }

    
    func renderUpdateForm(req: Request, form: UpdateForm) -> EventLoopFuture<View> {
        let formId = UUID().uuidString
        let nonce = req.generateNonce(for: "update-form", id: formId)

        return beforeUpdateFormRender(req: req, form: form).flatMap {
            var ctx = createContext(req: req, formId: formId, formToken: nonce).encodeToTemplateData().dictionary!
            ctx["fields"] = form.templateData.dictionary!["fields"]

            return render(req: req, template: updateView, context: ["form": .dictionary(ctx)])
        }
    }

    func accessUpdate(req: Request) -> EventLoopFuture<Bool> {
        req.checkAccess(for: Model.permission(for: .update))
    }
    
    func updateView(req: Request) throws -> EventLoopFuture<View>  {
        accessUpdate(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            let id = try identifier(req)
            let form = UpdateForm()
            return findBy(id, on: req.db).flatMap { model in
                return form.initialize(req: req).flatMap {
                    form.read(from: model as! UpdateForm.Model)
                    return renderUpdateForm(req: req, form: form)
                }
            }
        }
    }
    
    func beforeUpdate(req: Request, model: Model, form: UpdateForm) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }
    
    /*
     FLOW:
     ----
     check access
     validate incoming from with token
     create form
     initialize form
     process input form
     validate form
     if invalid:
        -> before invalid render we can still alter the form!
        -> render
     else:
     create / find the model
     write the form content to the model
     before update we can still alter the model
     update
     save form
     after create we can alter the model
     read the form with using new model
     createResponse (render the form)
     */
    func update(req: Request) throws -> EventLoopFuture<Response> {
        accessUpdate(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            try req.validateFormToken(for: "update-form")

            let id = try identifier(req)
            let form = UpdateForm()
            return form.initialize(req: req)
                .flatMap { form.process(req: req) }
                .flatMap { form.validate(req: req) }
                .throwingFlatMap { isValid in
                    guard isValid else {
                        return beforeInvalidUpdateFormRender(req: req, form: form)
                            .flatMap { renderUpdateForm(req: req, form: $0).encodeResponse(for: req) }
                    }
                    return findBy(id, on: req.db)
                        .map { form.write(to: $0 as! UpdateForm.Model); return $0; }
                        .flatMap { model in form.willSave(req: req, model: model as! UpdateForm.Model).map { model } }
                        .flatMap { beforeUpdate(req: req, model: $0, form: form) }
                        .flatMap { model in model.update(on: req.db).map { model } }
                        .flatMap { model in form.didSave(req: req, model: model as! UpdateForm.Model).map { model } }
                        .flatMap { afterUpdate(req: req, form: form, model: $0) }
                        .map { form.read(from: $0 as! UpdateForm.Model); return $0; }
                        .flatMap { model in form.save(req: req).map { model } }
                        .flatMap { updateResponse(req: req, form: form, model: $0) }
                }
        }
    }
    
    func updateApi(_ req: Request) throws -> EventLoopFuture<UpdateApi.GetObject> {
        accessUpdate(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            return req.eventLoop.future(error: Abort(.forbidden))

//            try Model.UpdateContent.validate(content: req)
//            let input = try req.content.decode(Model.UpdateContent.self)
//            return try findBy(identifier(req), on: req.db)
//                .flatMap { beforeUpdate(req: req, model: $0, content: input) }
//                .flatMapThrowing { model -> Model in
//                    try model.update(input)
//                    return model
//                }
//                .flatMap { model -> EventLoopFuture<Model.GetContent> in
//                    return model.update(on: req.db)
//                        .flatMap { afterUpdate(req: req, model: model) }
//                        .transform(to: model.getContent)
//                }
        }
    }

    func afterUpdate(req: Request, form: UpdateForm, model: Model) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }
    
    func updateResponse(req: Request, form: UpdateForm, model: Model) -> EventLoopFuture<Response> {
        renderUpdateForm(req: req, form: form).encodeResponse(for: req)
    }

    func setupUpdateRoutes(on builder: RoutesBuilder, as pathComponent: PathComponent) {
        builder.get(idPathComponent, pathComponent, use: updateView)
        builder.on(.POST, idPathComponent, pathComponent, use: update)
    }
    
    func setupUpdateApiRoute(on builder: RoutesBuilder) {
        builder.put(idPathComponent, use: updateApi)
    }
}
