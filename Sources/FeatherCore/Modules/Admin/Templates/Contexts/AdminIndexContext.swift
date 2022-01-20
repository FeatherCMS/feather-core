//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

public struct AdminIndexContext {

    public var title: String
    public var css: [String]
    public var js: [String]
    public var lang: String
    public var charset: String
    public var viewport: String
    public var breadcrumbs: [LinkContext]
    
    public init(title: String,
                css: [String] = ["/css/web/global.css", "/css/admin/admin.css"],
                js: [String] = [],
                lang: String = "en",
                charset: String = "utf-8",
                viewport: String = "width=device-width, initial-scale=1",
                breadcrumbs: [LinkContext] = []) {
        self.title = title
        self.css = css
        self.js = js
        self.lang = lang
        self.charset = charset
        self.viewport = viewport
        self.breadcrumbs = breadcrumbs
    }
}
