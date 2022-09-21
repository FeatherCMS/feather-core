//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import SwiftHtml

struct SystemAdminDashboardContext {

    struct WidgetGroupContext {
        let id: String
        let title: String
        let excerpt: String 
        let tags: [Tag]
    }
    
    let title: String
    let groups: [WidgetGroupContext]
}
