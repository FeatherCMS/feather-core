//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 07..
//

struct UserInstallController {

    private func render(req: Request, form: UserInstallForm) -> EventLoopFuture<View> {
        form.load(req: req).flatMap {
            req.view.render("User/Install/User", ["form": form])
        }
    }
    
    func userStep(req: Request) -> EventLoopFuture<View> {
        render(req: req, form: .init())
    }

    func performUserStep(req: Request, nextStep: String) -> EventLoopFuture<Response?> {

        let form = UserInstallForm()
        return form.load(req: req)
            .flatMap { form.read(req: req) }
            .flatMap { form.process(req: req) }
            .flatMap { form.validate(req: req) }
            .flatMap { isValid in
                guard isValid else {
                    form.error = "Invalid email or password"
                    return render(req: req, form: form).encodeOptionalResponse(for: req)
                }
                return form.write(req: req)
                    .flatMap { form.save(req: req) }
                    .flatMap {
                        Application.Config.installStep = nextStep
                        return req.eventLoop.future(nil)
                    }
            }
    }
}
