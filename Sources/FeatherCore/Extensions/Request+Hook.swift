//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 14..
//

import Vapor
import ViperKit

extension Request {
    
    func hookAll<T>(_ name: String, type: T.Type, params: [String : Any] = [:]) -> EventLoopFuture<[T]> {
        application.viper.invokeAllHooks(name: name, req: self, type: type, params: params)
    }
    
    func hook<T>(_ name: String, type: T.Type, params: [String : Any] = [:]) -> EventLoopFuture<T?> {
        application.viper.invokeHook(name: name, req: self, type: type, params: params)
    }
    
    func syncHookAll<T>(_ name: String, type: T.Type, params: [String : Any] = [:]) -> [T] {
        application.viper.invokeAllSyncHooks(name: name, req: self, type: type, params: params)
    }
    func syncHook<T>(_ name: String, type: T.Type, params: [String : Any] = [:]) -> T? {
        application.viper.invokeSyncHook(name: name, req: self, type: type, params: params)
    }
}
