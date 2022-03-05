//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 22..
//

import SwiftHtml
import FeatherIcons

struct SystemFileBrowserTemplate: TemplateRepresentable {
    
    var context: SystemFileBrowserContext
    
    init(_ context: SystemFileBrowserContext) {
        self.context = context
    }

    func currentKey(_ req: Request) -> String {
        if let key = try? req.query.get(String.self, at: "key") {
            return key
        }
        return ""
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        SystemIndexTemplate(.init(title: "File browser")) {//}, breadcrumbs: [
//            LinkContext(label: "System", dropLast: 1),
//        ])) {
            Wrapper {
                LeadTemplate(.init(title: "File browser",
                                   links: [
                                    .init(label: "Create directory",
                                          path: "/admin/common/files/directory/?key=" + currentKey(req),
                                          absolute: true),
                                    .init(label: "Upload files",
                                          path: "/admin/common/files/upload/?key=" + currentKey(req),
                                          absolute: true),
                                   ])).render(req)

                Table {
                    Thead {
                        Tr {
                            Td("Icon")
                            Td("Name")
                            if req.checkPermission("file.browser.delete") {
                                Td("Delete")
                                    .class("action")
                            }
                        }
                    }
                    Tbody {
                        if let parent = context.list.parent {
                            Tr {
                                Td {
                                    A {
                                        Svg.folder
                                    }
                                    .href((req.url.path.safePath() + "?key=" + parent.path))
                                }
                                Td {
                                    A("..")
                                        .href((req.url.path.safePath() + "?key=" + parent.path))
                                }
                                if req.checkPermission("file.browser.delete") {
                                    Td("&nbsp;")
                                        .class("action")
                                }
                            }
                        }
                        
                        for item in context.list.children {
                            Tr {
                                if let ext = item.ext?.lowercased() {
                                    if ["png", "jpg", "jpeg", "gif"].contains(ext) {
                                        Td {
                                            A {
                                                Img(src: req.fs.resolve(key: item.path), alt: item.name)
                                                    .style("width: 32px; max-height: 32px;")
                                            }
                                            .href(req.fs.resolve(key: item.path))
                                            .target(.blank)
                                        }
                                    }
                                    else {
                                        Td("file")
                                    }
                                }
                                else {
                                    Td {
                                        Svg.folder
                                    }
                                }
                                
                                Td {
                                    if item.ext != nil {
                                        A(item.name)
                                            .href(req.fs.resolve(key: item.path))
                                            .target(.blank)
                                    }
                                    else {
                                        A(item.name)
                                            .href((req.url.path.safePath() + "?key=" + item.path))
                                            
                                    }
                                }
                                if req.checkPermission("file.browser.delete") {
                                    Td {
                                        A("Delete")
                                            .href(("/admin/common/files/delete/".safePath() +
                                                   "?key=" + item.path +
                                                   "&cancel=" + req.url.path + "?key=" + currentKey(req) +
                                                   "&redirect=" + req.url.path + "?key=" + currentKey(req)))
                                    }
                                    .class("action")
                                }
                            }
                        }
                    }
                }
            }
        }
        .render(req)
    }
}


