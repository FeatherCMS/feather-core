//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

public protocol SystemInstallStepController: Controller {
    func handleInstallStep(_ req: Request, info: SystemInstallInfo) async throws -> Response?

    func installStep(_ req: Request, info: SystemInstallInfo) async throws -> Response
    func performInstallStep(_ req: Request, info: SystemInstallInfo) async throws -> Response?
    
    func continueInstall(_ req: Request, with nextStep: String) async throws
    func installPath(for step: String, next: Bool) -> String
}

public extension SystemInstallStepController {
    
    func continueInstall(_ req: Request, with nextStep: String) async throws {
        let steps: [SystemInstallStep] = req.invokeAllFlat(.installStep) + [.start, .finish]
        guard steps.map(\.key).contains(nextStep) else {
            throw Abort(.badRequest)
        }
        Feather.config.install.currentStep = nextStep
    }
    
    func installPath(for step: String, next: Bool = false) -> String {
        (Feather.config.paths.install + "/" + step).safePath() + ( next ? "?next=true" : "")
    }
    
    func performInstallStep(_ req: Request, info: SystemInstallInfo) async throws -> Response? { nil }
    
    func handleInstallStep(_ req: Request, info: SystemInstallInfo) async throws -> Response? {
        if info.performStep {
            return try await performInstallStep(req, info: info)
        }
        return try await installStep(req, info: info)
    }
}
