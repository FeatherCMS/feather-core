//
//  CreateViewController.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 12. 04..
//



public protocol CreateApiRepresentable: ModelApi {
    
    associatedtype CreateObject: Codable
    
    func validateCreate(_ req: Request) -> EventLoopFuture<Bool>
    func mapCreate(model: Model, input: CreateObject)
}

public protocol CreateController: ModelController {

    associatedtype CreateApi: CreateApiRepresentable & GetApiRepresentable
    associatedtype CreateForm: EditForm

    /// the name of the edit view template
    var createView: String { get }

    /// used after form validation when we have an invalid form
    func beforeInvalidCreateFormRender(req: Request, form: CreateForm) -> EventLoopFuture<CreateForm>
    
    /// this is called before the form rendering happens (used both in createView and updateView)
    func beforeCreateFormRender(req: Request, form: CreateForm) -> EventLoopFuture<Void>
    
    /// renders the form using the given template
    func renderCreateForm(req: Request, form: CreateForm) -> EventLoopFuture<View>

    /// check if there is access to create the object, if the future the server will respond with a forbidden status
    func accessCreate(req: Request) -> EventLoopFuture<Bool>

    /// this is the main view for the create controller
    func createView(req: Request) throws -> EventLoopFuture<View>
    
    /// this will be called before the model is saved to the database during the create event
    func beforeCreate(req: Request, model: Model, form: CreateForm) -> EventLoopFuture<Model>

    /// create handler for the form submission
    func create(req: Request) throws -> EventLoopFuture<Response>
    
    /// runs after the model has been created
    func afterCreate(req: Request, form: CreateForm, model: Model) -> EventLoopFuture<Model>

    /// returns a response after the create flow
    func createResponse(req: Request, form: CreateForm, model: Model) -> EventLoopFuture<Response>
    
    func createApi(_ req: Request) throws -> EventLoopFuture<CreateApi.GetObject>

    /// setup the get and post create routes using the given builder
    func setupCreateRoutes(on: RoutesBuilder, as: PathComponent)
    
    func setupCreateApiRoute(on builder: RoutesBuilder)
}

public extension CreateController {

    var createView: String { "System/Admin/Edit" }

    func beforeInvalidCreateFormRender(req: Request, form: CreateForm) -> EventLoopFuture<CreateForm> {
        req.eventLoop.future(form)
    }

    func beforeCreateFormRender(req: Request, form: CreateForm) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }

    func createContext(req: Request, formId: String, formToken: String) -> FormView {
        .init(id: formId,
              token: formToken,
              title: "",
              key: "",
              modelId: "",
              list: .init(label: "", url: ""),
              nav: [],
              notification: nil)
    }

    func renderCreateForm(req: Request, form: CreateForm) -> EventLoopFuture<View> {
        let formId = UUID().uuidString
        let nonce = req.generateNonce(for: "create-form", id: formId)

        return beforeCreateFormRender(req: req, form: form).flatMap {
            var ctx = createContext(req: req, formId: formId, formToken: nonce).encodeToTemplateData().dictionary!
            ctx["fields"] = form.templateData.dictionary!["fields"]

            return render(req: req, template: createView, context: ["form": .dictionary(ctx)])
            
        }
    }

    func accessCreate(req: Request) -> EventLoopFuture<Bool> {
        req.checkAccess(for: Model.permission(for: .create))
    }

    func createView(req: Request) throws -> EventLoopFuture<View>  {
        accessCreate(req: req).flatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            let form = CreateForm()
            return form.initialize(req: req).flatMap {
                renderCreateForm(req: req, form: form)
            }
        }
    }

    func beforeCreate(req: Request, model: Model, form: CreateForm) -> EventLoopFuture<Model> {
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
     before create we can still alter the model
     create
     call didSave model
     after create we can alter the model
     read the form with using new model
     call save form
     createResponse (render the form)
     */
    func create(req: Request) throws -> EventLoopFuture<Response> {
        accessCreate(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            try req.validateFormToken(for: "create-form")

            let form = CreateForm()
            return form.initialize(req: req)
                .flatMap { form.process(req: req) }
                .flatMap { form.validate(req: req) }
                .flatMap { isValid in
                    guard isValid else {
                        return beforeInvalidCreateFormRender(req: req, form: form).flatMap {
                            renderCreateForm(req: req, form: $0).encodeResponse(for: req)
                        }
                    }
                    let model = Model()
                    form.write(to: model as! CreateForm.Model)

                    return form.willSave(req: req, model: model as! CreateForm.Model)
                        .flatMap { beforeCreate(req: req, model: model, form: form) }
                        .flatMap { model in model.create(on: req.db).map { model } }
                        .flatMap { model in form.didSave(req: req, model: model as! CreateForm.Model ).map { model } }
                        .flatMap { afterCreate(req: req, form: form, model: $0) }
                        .map { model in form.read(from: model as! CreateForm.Model); return model; }
                        .flatMap { model in form.save(req: req).map { model } }
                        .flatMap { createResponse(req: req, form: form, model: $0) }
            }
        }
    }
    
    func afterCreate(req: Request, form: CreateForm, model: Model) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }
//
//    func createResponse(req: Request, form: CreateForm, model: Model) -> EventLoopFuture<Response> {
//        renderCreateForm(req: req, form: form).encodeResponse(for: req)
//    }
    
    /// after we create a new viper model we can redirect the user to the edit screen using the unique id and replace the last path component
    func createResponse(req: Request, form: CreateForm, model: Model) -> EventLoopFuture<Response> {
        let path = req.url.path.replacingLastPath(model.identifier)
        return req.eventLoop.future(req.redirect(to: path + "/" + Model.updatePathComponent.description + "/"))
    }

    func createApi(_ req: Request) throws -> EventLoopFuture<CreateApi.GetObject> {
        accessCreate(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }

            let api = CreateApi()

            return api.validateCreate(req).flatMap { isValid -> EventLoopFuture<CreateApi.Model> in
                guard isValid else {
                    return req.eventLoop.future(error: Abort(.badRequest))
                }
                do {
                    let input = try req.content.decode(CreateApi.CreateObject.self)
                    let model = Model() as! CreateApi.Model
                    api.mapCreate(model: model, input: input)
                    return req.eventLoop.future(model)
                }
                catch {
                    return req.eventLoop.future(error: Abort(.badRequest))
                }
            }
            .flatMap { model in model.create(on: req.db).map { model } }
            .map { api.mapGet(model: $0) }
        }
    }

    func setupCreateRoutes(on builder: RoutesBuilder, as pathComponent: PathComponent) {
        builder.get(pathComponent, use: createView)
        builder.on(.POST, pathComponent, use: create)
    }
    
    func setupCreateApiRoute(on builder: RoutesBuilder) {
        builder.post(use: createApi)
    }
}

