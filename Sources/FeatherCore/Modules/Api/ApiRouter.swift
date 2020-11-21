//
//  ApiRouter.swift
//  Feather
//
//  Created by Tibor Bödecs on 2020. 06. 09..
//

final class ApiRouter: ViperRouter {

    func routesHook(args: HookArguments) {
        let app = args["app"] as! Application
        let routes = args["routes"] as! RoutesBuilder
        let publicApi = routes.grouped("api")

        /// register publicly available api routes
        let _: [Void] = app.hooks.invokeAll("public-api", args: ["routes": publicApi])

        /// guard the api with auth middlewares, if there was no auth middlewares returned we simply stop the registration
        let middlewares: [[Middleware]] = app.hooks.invokeAll("api-auth-middlwares")

        /// register protected api endpoints
        let protectedApi = publicApi.grouped(middlewares.flatMap { $0 })
        let _: [Void] = app.hooks.invokeAll("api", args: ["routes": protectedApi])
    }
}
