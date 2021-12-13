//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import Foundation

public struct AdminIndexContext {
    var title: String
    var css: [String] = ["/css/global.css", "/style.css"]
    var js: [String] = []
    var lang: String = "en"
    var charset: String = "utf-8"
    var viewport: String = "width=device-width, initial-scale=1"

    var breadcrumbs: [LinkContext]
}
