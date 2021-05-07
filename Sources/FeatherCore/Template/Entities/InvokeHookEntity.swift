//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 27..
//

struct InvokeHookEntity: UnsafeEntity, NonMutatingMethod, StringReturn {

    var unsafeObjects: UnsafeObjects? = nil

    static var callSignature: [CallParameter] { [.string] }

    init() {}
    
    func evaluate(_ params: CallValues) -> TemplateData {
        guard let app = app else { return .error("Needs unsafe access to Application") }
        let name = params[0].string! + "-template"
        let result: TemplateDataRepresentable? = app.invoke(name)
        return result?.templateData ?? .trueNil
    }
}

