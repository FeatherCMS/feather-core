//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

public struct SystemIndexContext {

    public var title: String
    public var css: [String]
    public var js: [String]
    public var lang: String
    public var charset: String
    public var viewport: String
    public var noindex: Bool
    public var canonicalUrl: String?
    public var metadata: FeatherMetadata?
    
    public init(title: String,
                css: [String] = ["/css/system/global.css"],
                js: [String] = [],
                lang: String = "en",
                charset: String = "utf-8",
                viewport: String = "width=device-width, initial-scale=1",
                noindex: Bool = false,
                canonicalUrl: String? = nil,
                metadata: FeatherMetadata? = nil) {
        self.title = title
        self.css = css
        self.js = js
        self.lang = lang
        self.charset = charset
        self.viewport = viewport
        self.noindex = noindex
        self.metadata = metadata
        self.canonicalUrl = canonicalUrl
    }
}
