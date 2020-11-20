//
//  ApiModule.swift
//  Feather
//
//  Created by Tibor Bödecs on 2020. 06. 09..
//

final class ApiModule: ViperModule {

    static var name: String = "api"
    var priority: Int { 100 }

    var router: ViperRouter? { ApiRouter() }
}
