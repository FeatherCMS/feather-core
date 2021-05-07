//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 07..
//

public extension Request {

    func continueInstall(with nextStep: String) -> EventLoopFuture<Void> {
        let steps: [[InstallStep]] = invokeAll(.installStep)
        let flatSteps = steps.flatMap { $0 }.map { $0.key }
        /// NOTE: check if next step comes after the current step?
        if flatSteps.contains(nextStep) {
            Application.Config.installStep = nextStep
        }
        return eventLoop.future()
    }
}
