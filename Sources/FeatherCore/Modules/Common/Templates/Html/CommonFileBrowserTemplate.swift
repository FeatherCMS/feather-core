//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 22..
//

import SwiftHtml

struct CommonFileBrowserTemplate: TemplateRepresentable {
    
    var context: CommonFileBrowserContext
    
    init(_ context: CommonFileBrowserContext) {
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
        AdminIndexTemplate(.init(title: "File browser")) {
            Div {
                Div {
                    H1("File browser")
                    
                    A("Create directory")
                        .href("/admin/common/files/directory/?key=" + currentKey(req))
                    
                    A("Upload files")
                        .href("/admin/common/files/upload/?key=" + currentKey(req))
                }
                .class("lead")

                
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
                                        Img(src: "/svg/web/folder.svg", alt: parent.key)
                                            .style("width: 32px; height: 32px;")
                                    }
                                    .href((req.url.path.safePath() + "?key=" + parent.key))
                                }
                                Td {
                                    A("..")
                                        .href((req.url.path.safePath() + "?key=" + parent.key))
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
                                                Img(src: req.fs.resolve(key: item.key), alt: item.name)
                                                    .style("width: 32px; max-height: 32px;")
                                            }
                                            .href(req.fs.resolve(key: item.key))
                                            .target(.blank)
                                        }
                                    }
                                    else {
                                        Td("file")
                                    }
                                }
                                else {
                                    Td {
                                        Img(src: "/svg/web/folder.svg", alt: item.key)
                                            .style("width: 32px; height: 32px;")
                                    }
                                }
                                
                                Td {
                                    if item.ext != nil {
                                        A(item.name)
                                            .href(req.fs.resolve(key: item.key))
                                            .target(.blank)
                                    }
                                    else {
                                        A(item.name)
                                            .href((req.url.path.safePath() + "?key=" + item.key))
                                            
                                    }
                                }
                                if req.checkPermission("file.browser.delete") {
                                    Td {
                                        A("Delete")
                                            .href(("/admin/common/files/delete/".safePath() +
                                                   "?key=" + item.key +
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


