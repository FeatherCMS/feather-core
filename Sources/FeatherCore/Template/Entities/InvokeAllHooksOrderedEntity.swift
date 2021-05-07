//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 07..
//

struct InvokeAllHooksOrderedEntity: UnsafeEntity, NonMutatingMethod, StringReturn {
    var unsafeObjects: UnsafeObjects? = nil

    static var callSignature: [CallParameter] { [.string] }

    init() {}
    
    func evaluate(_ params: CallValues) -> TemplateData {
        guard let app = app else { return .error("Needs unsafe access to Application") }
        let name = params[0].string! + "-template"

        let result: [[OrderedTemplateData]] = app.invokeAll(name)
        let sortedFlatResult = result.flatMap { $0 }.sorted { $0.order > $1.order }.map { $0.object }
        return .array(sortedFlatResult.map(\.templateData))
    }
}

