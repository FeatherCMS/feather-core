//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 09..
//

import SwiftHtml

struct FooterContext {


}

struct FooterTemplate: TemplateRepresentable {
    
    private func getTitle(_ req: Request) -> String {
        req.variable("webSiteTitle") ?? ""
    }
    
    let context: FooterContext
    
    init(_ context: FooterContext) {
        self.context = context
    }

    func render(_ req: Request) -> Tag {
        Footer {
            Div {
                Div {
                    Div {
                        Section {
                            H4("Main")
                            Ul {
                                req.menuItems("main").map { ctx -> Tag in
                                    Li {
                                        LinkTemplate(ctx).render(req)
                                    }
                                }
                            }
                        }
                        Section {
                            H4("Footer")
                            Ul {
                                req.menuItems("footer").map { ctx -> Tag in
                                    Li {
                                        LinkTemplate(ctx).render(req)
                                    }
                                }
                            }
                        }
                        Section {
                            H4("User")
                            Ul {
                                if req.auth.has(FeatherAccount.self) {
                                    if req.checkPermission(Admin.permission(for: .detail)) {
                                        Li {
                                            A("Admin")
                                                .href(req.feather.config.paths.admin.safePath())
                                        }
                                    }
                                    Li {
                                        A("Sign out")
                                            .href(req.feather.config.paths.logout.safePath())
                                    }
                                }
                                else {
                                    Li {
                                        A("Sign in")
                                            .href(req.feather.config.paths.login.safePath())
                                    }
                                }
                            }
                        }
                        Section {
                            H4("Links")
                            Ul {
                                Li {
                                    A("Feather")
                                        .href("https://feathercms.com/")
                                        .target(.blank)
                                }
                                Li {
                                    A("Vapor")
                                        .href("https://vapor.codes/")
                                        .target(.blank)
                                }
                                Li {
                                    A("Swift")
                                        .href("https://swift.org/")
                                        .target(.blank)
                                }
                            }
                        }
                    }
                    .class("grid-421")    
                }
                .class("wrapper")
                
                P("\(getTitle(req)) &copy; \(Calendar.current.component(.year, from: Date()))")
            }
            .class("safe-area")
        }
    }
}



//
//<div class="grid-421">
//    <div>
//        <h4>Admin</h4>
//        <ul>
//            <li><a href="/admin/">Dashboard</a></li>
//            <li><a href="/table/">Table</a></li>
//            <li><a href="/edit/">Edit</a></li>
//            <li><a href="/detail/">Detail</a></li>
//            <li><a href="/delete/">Delete</a></li>
//        </ul>
//    </div>
//    <div>
//        <h4>Frontend</h4>
//        <ul>
//            <li><a href="/">Home</a></li>
//            <li><a href="/articles/">Articles</a></li>
//            <li><a href="/article/">Article</a></li>
//            <li><a href="/blog/">Blog</a></li>
//            <li><a href="/categories/">Categories</a></li>
//        </ul>
//    </div>
//    <div>
//        <h4>Footer 3</h4>
//        <ul>
//            <li><a href="/typography/">Typography</a></li>
//            
//            <li><a href="/form/">Form</a></li>
//        </ul>
//    </div>
//    <div>
//        <h4>Footer 4</h4>
//        <ul>
//            <li><a href="">Lorem</a></li>
//            <li><a href="">Ipsum</a></li>
//            <li><a href="">Dolor</a></li>
//            <li><a href="">Sit</a></li>
//            <li><a href="">Amet</a></li>
//        </ul>
//    </div>
//</div>
