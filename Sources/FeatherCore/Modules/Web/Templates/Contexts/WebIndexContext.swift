//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 18..
//

public struct WebIndexContext {

    public struct Metadata {
        var title: String
        var description: String
        var url: String
        var image: String
        
        public init(title: String, description: String, url: String, image: String) {
            self.title = title
            self.description = description
            self.url = url
            self.image = image
        }
    }
    
    public var title: String
    public var css: [String]
    public var js: [String]
    public var lang: String
    public var charset: String
    public var viewport: String
    public var noindex: Bool
    public var metadata: Metadata?
    public var canonicalUrl: String?
    
    public init(title: String,
                css: [String] = ["/css/web/global.css"],
                js: [String] = [],
                lang: String = "en",
                charset: String = "utf-8",
                viewport: String = "width=device-width, initial-scale=1",
                noindex: Bool = false,
                metadata: Metadata? = nil,
                canonicalUrl: String? = nil) {
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
