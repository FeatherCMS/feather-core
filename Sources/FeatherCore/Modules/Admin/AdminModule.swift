//
//  AdminModule.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 28..
//

final class AdminModule: ViperModule {

    static let name = "admin"
    var priority: Int { 100 }
    
    var router: ViperRouter? = AdminRouter()

//    var bundleUrl: URL? {
//        nil
//    }
}
