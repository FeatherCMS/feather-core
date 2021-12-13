//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Foundation
import SwiftHtml

struct CommonAdminWidgetTemplate: TemplateRepresentable {
    
    @TagBuilder
    var tag: Tag {
        H2("Common")
        Ul {
            Li {
                A("Variables")
                    .href("common/variables/")
            }
        }
    }
}
