//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 27..
//

public struct InvokeAllHooksEntity: UnsafeEntity, NonMutatingMethod, StringReturn {
    public var unsafeObjects: UnsafeObjects? = nil

    public static var callSignature: [CallParameter] { [.string] }

    public init() {}
    
    public func evaluate(_ params: CallValues) -> TemplateData {
        guard let app = app else { return .error("Needs unsafe access to Application") }
        let name = params[0].string! + "-template"
        let result: [TemplateDataRepresentable] = app.invokeAll(name)
        return .array(result.map(\.templateData))
    }
}
