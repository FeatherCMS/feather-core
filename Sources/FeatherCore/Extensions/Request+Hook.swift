//
//  Request+Hook.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 14..
//

import Vapor
import ViperKit

public extension Request {
    
    /// shorthand for the viper.invokeAllHooks method
    func hookAll<T>(_ name: String, type: T.Type, params: [String : Any] = [:]) -> EventLoopFuture<[T]> {
        application.viper.invokeAllHooks(name: name, req: self, type: type, params: params)
    }
    
    /// shorthand for the viper.invokeHook method
    func hook<T>(_ name: String, type: T.Type, params: [String : Any] = [:]) -> EventLoopFuture<T?> {
        application.viper.invokeHook(name: name, req: self, type: type, params: params)
    }
    
    /// shorthand for the viper.invokeAllSyncHooks method
    func syncHookAll<T>(_ name: String, type: T.Type, params: [String : Any] = [:]) -> [T] {
        application.viper.invokeAllSyncHooks(name: name, req: self, type: type, params: params)
    }
    
    /// shorthand for the viper.invokeSyncHook method
    func syncHook<T>(_ name: String, type: T.Type, params: [String : Any] = [:]) -> T? {
        application.viper.invokeSyncHook(name: name, req: self, type: type, params: params)
    }
}
