//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

public struct SystemInstallInfo {
    internal init(currentStep: String, nextStep: String, performStep: Bool) {
        self.currentStep = currentStep
        self.nextStep = nextStep
        self.performStep = performStep
    }
    
    public let currentStep: String
    public let nextStep: String
    public let performStep: Bool
    
}
