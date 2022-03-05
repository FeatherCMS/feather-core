//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

import Vapor

public final class TemplateEngine {
    
    var templates: [FeatherTemplate]
    var app: Application
    
    init(app: Application) {
        self.app = app
        self.templates = []
    }

    public func register(_ object: FeatherTemplate) {
        templates.append(object)
    }

    public func get<T>(_ key: T.Type) -> T {
        guard let tpl = templates.first(where: { $0 is T }) else {
            fatalError("Missing template type `\(T.self)`")
        }
        return tpl as! T
    }

}

public extension Application {

    private struct TemplateEngineKey: StorageKey {
        typealias Value = TemplateEngine
    }

    var templateEngine: TemplateEngine {
        get {
            if let existing = storage[TemplateEngineKey.self] {
                return existing
            }
            let new = TemplateEngine(app: self)
            storage[TemplateEngineKey.self] = new
            return new
        }
        set {
            storage[TemplateEngineKey.self] = newValue
        }
    }
}

public extension Request {

    var templateEngine: TemplateEngine {
        application.templateEngine
    }
}
