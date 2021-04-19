//
//  UserAdminController.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//


struct SystemUserController: FeatherController {

    typealias Module = SystemModule
    typealias Model = SystemUserModel
    
    typealias CreateForm = SystemUserEditForm
    typealias UpdateForm = SystemUserEditForm
    
    typealias GetApi = SystemVariableApi
    typealias ListApi = SystemVariableApi
    typealias CreateApi = SystemVariableApi
    typealias UpdateApi = SystemVariableApi
    typealias PatchApi = SystemVariableApi
    typealias DeleteApi = SystemVariableApi

    // MARK: - login

    func login(req: Request) throws -> EventLoopFuture<TokenObject> {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }
        let tokenValue = [UInt8].random(count: 16).base64
        let token = SystemTokenModel(value: tokenValue, userId: user.id)
        return token.create(on: req.db).map { token.getContent }
    }
    
    // MARK: - api
    
    func findBy(_ id: UUID, on db: Database) -> EventLoopFuture<Model> {
        Model.findWithRolesBy(id: id, on: db).unwrap(or: Abort(.notFound, reason: "User not found"))
    }

    func afterCreate(req: Request, form: CreateForm, model: Model) -> EventLoopFuture<Model> {
        findBy(model.id!, on: req.db)
    }

    func afterUpdate(req: Request, form: UpdateForm, model: Model) -> EventLoopFuture<Model> {
        findBy(model.id!, on: req.db)
    }

    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        Model.query(on: req.db).count().flatMap { count in
            if count == 1 {
                return req.eventLoop.future(error: Abort(.badRequest, reason: "You can't delete every user"))
            }
            return SystemTokenModel.query(on: req.db).filter(\.$user.$id == model.id!).delete().map { model }
        }
    }

    
    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["email"], rows: models.map { model in
            TableRow(id: model.identifier, cells: [TableCell(model.email)])
        })
    }

    func getContext(req: Request, model: Model) -> GetViewContext {
        .init(title: "User",
              key: "system.users",
              list: .init(label: "Users", url: "/admin/system/users/"),
              nav: [],
              fields: [
                .init(label: "Id", value: model.identifier),
                .init(label: "Email", value: model.email),
                .init(label: "Has root access?", value: model.root ? "Yes" : "No"),
                .init(label: "Roles", value: model.roles.map(\.name).joined(separator: "<br>")),
              ])
    }
    
    func deleteContext(req: Request, model: Model, formId: String, formToken: String) -> DeleteControllerContext {
        .init(id: formId,
              token: formToken,
              context: model.email,
              type: "user",
              list: .init(label: "Users", url: "/admin/system/users")
        )
    }

}
