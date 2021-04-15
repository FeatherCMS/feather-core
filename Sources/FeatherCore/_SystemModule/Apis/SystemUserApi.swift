//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

struct SystemUserApi: CreateApiRepresentable, GetApiRepresentable {
    typealias Model = SystemUserModel
    typealias CreateObject = String
    typealias GetObject = String
    
    func login(req: Request) throws -> EventLoopFuture<TokenObject> {
        guard let user = req.auth.get(SystemUserModel.self) else {
            throw Abort(.unauthorized)
        }
        let tokenValue = [UInt8].random(count: 16).base64
        let token = SystemTokenModel(value: tokenValue, userId: user.id!)
        return token.create(on: req.db).map { token.getContent }
    }
}

