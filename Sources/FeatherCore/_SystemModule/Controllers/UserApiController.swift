//
//  UserApiContentController.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 12. 21..
//




struct UserApiContentController: ApiContentController {
    typealias Module = SystemModule
    typealias Model = SystemUserModel
    
    /// after a succesful user authentication this method returns a token for a given user
    func login(req: Request) throws -> EventLoopFuture<TokenObject> {
        guard let user = req.auth.get(SystemUserModel.self) else {
            throw Abort(.unauthorized)
        }
        let tokenValue = [UInt8].random(count: 16).base64
        let token = SystemTokenModel(value: tokenValue, userId: user.id!)
        return token.create(on: req.db).map { token.getContent }
    }
}
